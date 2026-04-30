//
//  PhraseDetailDisplayable.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/30.
//

import Foundation

protocol PhraseDetailDisplayable: PhraseDisplayable {
    var displayDetailedMeaning: String { get }
    var displayContexts: [String] { get }
    var displayCollocations: [Collocation] { get }
    var displayOrigin: String { get }
    var displayTips: String { get }
    var displaySimilar: [SimilarPhrase] { get }
}
