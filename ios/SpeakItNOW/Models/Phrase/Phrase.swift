//
//  Phrase.swift
//  
//
//  Created by 助名直人 on 2026/01/15.
//
import Foundation

/// 画面共通で扱うフレーズ
struct Phrase: Identifiable, Codable, Hashable {
    let id: Int
    let text: String
    let meaningJa: String
    let normalizedText: String
    let phraseDetails: PhraseDetails

    // 将来の拡張（必要になったら使う）
    var tags: [String]?
    var isSaved: Bool?
}

extension Phrase: PhraseDetailDisplayable {
    var displayText: String { text }
    var displayMeaningJa: String { meaningJa }
    var displayDetailedMeaning: String { phraseDetails.detailedMeaning }
    var displayContexts: [String] { phraseDetails.contexts }
    var displayCollocations: [Collocation] { phraseDetails.collocations }
    var displayOrigin: String { phraseDetails.origin }
    var displayTips: String { phraseDetails.tips }
    var displaySimilar: [SimilarPhrase] { phraseDetails.similar }
}
