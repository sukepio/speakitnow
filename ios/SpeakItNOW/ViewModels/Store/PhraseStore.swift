//
//  PhraseStore.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

@MainActor
final class PhraseStore: ObservableObject {
    @Published var myPhrases: [Phrase] = []
    @Published var selectedPhraseId: Int?
    @Published var myPhraseIds: Set<Int> = []
    @Published var errorMessage: String?
    
    private let repository = PhraseRepository()
    private let userPhraseRepository = UserPhraseRepository()
    
    init() {
        self.myPhrases = []
    }
    
    func loadMyPhrases() async {
        do {
            self.myPhraseIds = try await userPhraseRepository.fetchMyPhraseIds()
            self.myPhrases = try await repository.fetchPhrases(ids: Array(self.myPhraseIds))
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func isAdded(_ phrase: Phrase) -> Bool {
        return myPhraseIds.contains(phrase.id)
    }
    
    func addMyPhrase(_ phrase: Phrase) async {
        do {
            try await userPhraseRepository.addMyPhrase(phraseId: phrase.id)
            
            self.myPhraseIds.insert(phrase.id)
            
            if !myPhrases.contains(where: { $0.id == phrase.id }) {
                self.myPhrases.append(phrase)
            }
            
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func removeMyPhrase(_ phrase: Phrase) async {
        do {
            try await userPhraseRepository.removeMyPhrase(phraseId: phrase.id)
            self.myPhraseIds.remove(phrase.id)
            self.myPhrases.removeAll { $0.id == phrase.id }
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
