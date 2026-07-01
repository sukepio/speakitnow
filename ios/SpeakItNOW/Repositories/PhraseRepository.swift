//
//  SupabaseRepository.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/06.
//

import Foundation
import Supabase

final class PhraseRepository {
    let supabase = SupabaseClient(
      supabaseURL: URL(string: "https://myajfjhsmscznlknhrxh.supabase.co")!,
      supabaseKey: "sb_publishable_bFMICOIn2u382RMOqn-QFg_6UsF4mwG"
    )
    
    func getPhrases() async throws -> [Phrase] {
        let phrases: [PhraseDTO] = try await fetchPhrases()
        return convertToPhrase(phrases: phrases)
    }
    
    func searchPhrases(query: String) async throws -> [Phrase] {
        
        let normalizedQuery = normalize(query: query)
        
        // 完全一致検索
        let exactMatchesForQuery: [PhraseDTO] = try await searchExactPhrases(normalizedQuery: normalizedQuery)
        if !exactMatchesForQuery.isEmpty {
            return convertToPhrase(phrases: exactMatchesForQuery)
        }
        
        // 部分一致検索
        let partialPhrases: [PhraseDTO] = try await searchPartialPhrases(normalizedQuery: normalizedQuery)
        if !partialPhrases.isEmpty {
            return convertToPhrase(phrases: partialPhrases)
        }
        
        // LLM生成
        let generatedPhrase: LLMGeneratedPhraseDTO = try await generatePhrase(query: query)
        let generatedPhraseNormalizedText = normalize(query: generatedPhrase.text)
        
        // 再度完全一致検索
        let exactMatchesForGeneratedPhrase = try await searchExactPhrases(normalizedQuery: generatedPhraseNormalizedText)
        if !exactMatchesForGeneratedPhrase.isEmpty {
            return convertToPhrase(phrases: exactMatchesForGeneratedPhrase)
        }
        
        // insert用DTO詰め替え
        let phraseInsertDTO: PhraseInsertDTO = convertToPhraseInsertDTO(
            generatedPhrase: generatedPhrase,
            normalizedText: generatedPhraseNormalizedText
        )
        
        // LLM生成保存
        do {
            let insertedPhrase: Phrase = try await insertPhrase(phrase: phraseInsertDTO)
            return [insertedPhrase]
        } catch {
            if isUniqueViolation(error){
                let exactMatchesForUniqueViolation = try await searchExactPhrases(normalizedQuery: generatedPhraseNormalizedText)
                
                if !exactMatchesForUniqueViolation.isEmpty {
                    return convertToPhrase(phrases: exactMatchesForUniqueViolation)
                }
                
                throw error
            }
        }
        
        return []
    }
    
    private func normalize(query: String) -> String {
        var normalized = query.lowercased()
        normalized = normalized.trimmingCharacters(in: .whitespacesAndNewlines)
        normalized = normalized.replacingOccurrences(of: "-", with: " ")
        normalized = normalized.components(separatedBy: .whitespacesAndNewlines).filter{
            !$0.isEmpty
        }.joined(separator: " ")
        return normalized
    }
    
    private func searchExactPhrases(normalizedQuery: String) async throws -> [PhraseDTO] {
        let phrases: [PhraseDTO] = try await supabase
            .from("phrases")
            .select("id, text, meaning_ja, normalized_text, phrase_details")
            .equals("normalized_text", value: normalizedQuery)
            .execute()
            .value
        return phrases
    }
    
    private func searchPartialPhrases(normalizedQuery: String) async throws -> [PhraseDTO] {
        let phrases: [PhraseDTO] = try await supabase
            .from("phrases")
            .select("id, text, meaning_ja, normalized_text, phrase_details")
            .ilike("normalized_text", pattern: "%\(normalizedQuery)%")
            .execute()
            .value
        return phrases
    }
    
    private func generatePhrase(query: String) async throws -> LLMGeneratedPhraseDTO {
        let response: LLMGeneratedPhraseDTO = try await supabase.functions
          .invoke(
            "generate-phrase",
            options: FunctionInvokeOptions(
              body: ["query": query]
            )
          )
        return response
    }
    
    private func convertToPhrase(phrases: [PhraseDTO]) -> [Phrase] {
        phrases.map { dto in
            Phrase(
                id: dto.id,
                text: dto.text,
                meaningJa: dto.meaning_ja,
                normalizedText: dto.normalized_text,
                phraseDetails: convertToPhraseDetails(dto.phrase_details)
            )
        }
    }
    
    private func convertToPhraseDetails(_ dto: PhraseDetailsDTO) -> PhraseDetails {
        PhraseDetails(
            detailedMeaning: dto.detailed_meaning,
            contexts: dto.contexts,
            conversations: dto.conversations.map { convertToConversation($0) },
            collocations: dto.collocations.map { convertToCollocation($0) },
            examples: dto.examples.map { convertToExample($0) },
            origin: dto.origin,
            tips: dto.tips,
            similar: dto.similar.map { convertToSimilarPhrase($0) }
        )
    }
    
    private func convertToConversation(_ dto: ConversationDTO) -> Conversation {
        Conversation(
            id: dto.id,
            text: dto.text,
            meaningJa: dto.meaning_ja,
            conversationPair: convertToConversationPair(dto.conversation_pair)
        )
    }
    
    private func convertToConversationPair(_ dto: ConversationPairDTO) -> ConversationPair {
        ConversationPair(
            first: convertToBilingualText(dto.first),
            second: convertToBilingualText(dto.second))
    }
    
    private func convertToBilingualText(_ dto: BilingualTextDTO) -> BilingualText {
        BilingualText(
            en: dto.en,
            ja: dto.ja
        )
    }
    
    private func convertToCollocation(_ dto: CollocationDTO) -> Collocation {
        Collocation(
            id: dto.id,
            text: dto.text,
            meaningJa: dto.meaning_ja,
            conversationPair: convertToConversationPair(dto.conversation_pair))
    }
    
    private func convertToExample(_ dto: ExampleDTO) -> Example {
        Example(
            id: dto.id,
            en: dto.en,
            ja: dto.ja
        )
    }
    
    private func convertToSimilarPhrase(_ dto: SimilarPhraseDTO) -> SimilarPhrase {
        SimilarPhrase(
            id: dto.id,
            phrase: dto.phrase,
            meaningJa: dto.meaning_ja
        )
    }
    
    private func fetchPhrases() async throws -> [PhraseDTO] {
        let phrases : [PhraseDTO] = try await supabase.from("phrases").select("id, text, meaning_ja, phrase_details").limit(1).execute().value
        return phrases
    }
    
    private func convertToPhraseInsertDTO(generatedPhrase: LLMGeneratedPhraseDTO, normalizedText: String) -> PhraseInsertDTO {
            PhraseInsertDTO(
                text: generatedPhrase.text,
                meaning_ja: generatedPhrase.meaning_ja,
                normalized_text: normalizedText,
                phrase_details: generatedPhrase.phrase_details
            )
    }
    
    private func convertToPhrase(dto: PhraseDTO) -> Phrase {
        Phrase(
            id: dto.id,
            text: dto.text,
            meaningJa: dto.meaning_ja,
            normalizedText: dto.normalized_text,
            phraseDetails: convertToPhraseDetails(dto.phrase_details)
        )
    }

    private func insertPhrase(phrase: PhraseInsertDTO) async throws -> Phrase {
        let insertedDTO: PhraseDTO = try await supabase
            .from("phrases")
            .insert(phrase)
            .select("id, text, meaning_ja, normalized_text, phrase_details")
            .single()
            .execute()
            .value
        
        return convertToPhrase(dto: insertedDTO)
        
    }
    
    private func isUniqueViolation(_ error: Error) -> Bool {
        let message = String(describing: error)
        return message.contains("23505")
    }
    
}
