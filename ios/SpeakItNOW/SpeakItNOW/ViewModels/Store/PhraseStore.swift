//
//  PhraseStore.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

final class PhraseStore: ObservableObject {
    @Published var phrases: [Phrase] = []
    @Published var selectedPhraseId: String?
    
    init() {
        self.phrases = MockPhraseData.phrases
    }
    
    var recommendedPhrases: [Phrase] {
        phrases.filter{ $0.isRecommended }
    }
}
