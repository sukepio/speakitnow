//
//  File.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/17.
//

import Foundation

struct GeneratedPhrase: Identifiable {
    var id: String { normalizedText }
    let text: String
    let meaningJa: String
    let normalizedText: String
    let phraseDetails: PhraseDetails
}

extension GeneratedPhrase: PhraseDetailDisplayable {
    var displayText: String { text }
    var displayMeaningJa: String { meaningJa }
    var displayDetailedMeaning: String { phraseDetails.detailedMeaning }
    var displayContexts: [String] { phraseDetails.contexts }
    var displayCollocations: [Collocation] { phraseDetails.collocations }
    var displayOrigin: String { phraseDetails.origin }
    var displayTips: String { phraseDetails.tips }
    var displaySimilar: [SimilarPhrase] { phraseDetails.similar }
}
