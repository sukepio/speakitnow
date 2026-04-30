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
        let exactPhrases: [PhraseDTO] = try await searchExactPhrases(normalizedQuery: normalizedQuery)
        if !exactPhrases.isEmpty {
            return convertToPhrase(phrases: exactPhrases)
        }
        
        // 部分一致検索
        let partialPhrases: [PhraseDTO] = try await searchPartialPhrases(normalizedQuery: normalizedQuery)
        if !partialPhrases.isEmpty {
            return convertToPhrase(phrases: partialPhrases)
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
        let phrases: [PhraseDTO] = try await supabase.from("phrases").select("id, text, meaning_ja, phrase_details").equals("normalized_text", value: normalizedQuery).execute().value
        return phrases
    }
    
    private func searchPartialPhrases(normalizedQuery: String) async throws -> [PhraseDTO] {
        let phrases: [PhraseDTO] = try await supabase.from("phrases").select("id, text, meaning_ja, phrase_details").ilike("normalized_text", pattern: "%\(normalizedQuery)%").execute().value
        return phrases
    }
    
    // TODO: api call
    
    private func convertToPhrase(phrases: [PhraseDTO]) -> [Phrase] {
        phrases.map { dto in
            Phrase(
                id: String(dto.id),
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
    

    
    
}
