//
//  PhraseStore.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

@MainActor
final class PhraseStore: ObservableObject {
    @Published var phrases: [Phrase] = []
    @Published var selectedPhraseId: String?
    @Published var myPhraseIds: Set<String> = []
    @Published var errorMessage: String?
    
    private let repository = PhraseRepository()
    
    var myPhrases: [Phrase] {
        phrases.filter{ myPhraseIds.contains($0.id) }
    }
    
    init() {
        self.phrases = []
    }
    
//    var recommendedPhrases: [Phrase] {
//        phrases.filter{ $0.isRecommended }
//    }
    
    func loadPhrases() async {
        //TODO: 成功したらphrasesを入れる。失敗したらerrorMessagesを入れる
        do {
            self.phrases = try await repository.getPhrases()
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func isAdded(_ phrase: Phrase) -> Bool {
        return myPhraseIds.contains(phrase.id)
    }
    
    func addMyPhrase(_ phrase: Phrase) {
        myPhraseIds.insert(phrase.id)
    }
    
    func removeMyPhrase(_ phrase: Phrase) {
        myPhraseIds.remove(phrase.id)
    }
}
