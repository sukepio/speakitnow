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
        Task {
            await self.loadMyPhrases()
        }
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
        // Optimistic update: update local state immediately
        let previousIds = myPhraseIds
        let previousPhrases = myPhrases

        self.myPhraseIds.insert(phrase.id)
        if !self.myPhrases.contains(where: { $0.id == phrase.id }) {
            self.myPhrases.append(phrase)
        }

        do {
            try await userPhraseRepository.addMyPhrase(phraseId: phrase.id)
            self.errorMessage = nil
        } catch {
            // Rollback on failure
            self.myPhraseIds = previousIds
            self.myPhrases = previousPhrases
            self.errorMessage = error.localizedDescription
        }
    }
    
    func removeMyPhrase(_ phrase: Phrase) async {
        // Optimistic update: remove locally first
        let previousIds = myPhraseIds
        let previousPhrases = myPhrases

        self.myPhraseIds.remove(phrase.id)
        self.myPhrases.removeAll { $0.id == phrase.id }

        do {
            try await userPhraseRepository.removeMyPhrase(phraseId: phrase.id)
            self.errorMessage = nil
        } catch {
            // Rollback on failure
            self.myPhraseIds = previousIds
            self.myPhrases = previousPhrases
            self.errorMessage = error.localizedDescription
        }
    }
}

