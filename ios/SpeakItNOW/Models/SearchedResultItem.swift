//
//  SearchedResultItem.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/14.
//

import Foundation

struct SearchedResultItem: Identifiable {
    let content: SearchResultContent
    
    var id: String {
        switch content {
        case .saved(let phrase):
            return phrase.normalizedText
        case .generated(let generatedPhrase):
            return generatedPhrase.normalizedText
        }
    }
}

enum SearchResultContent {
    case saved(Phrase)
    case generated(GeneratedPhrase)
}

extension SearchResultContent: PhraseDetailDisplayable {
    var displayText: String {
        switch self {
        case .saved(let phrase):
            return phrase.displayText
        case .generated(let generatedPhrase):
            return generatedPhrase.displayText
        }
    }

    var displayMeaningJa: String {
        switch self {
        case .saved(let phrase):
            return phrase.displayMeaningJa
        case .generated(let generatedPhrase):
            return generatedPhrase.displayMeaningJa
        }
    }

    var displayDetailedMeaning: String {
        switch self {
        case .saved(let phrase):
            return phrase.displayDetailedMeaning
        case .generated(let generatedPhrase):
            return generatedPhrase.displayDetailedMeaning
        }
    }

    var displayContexts: [String] {
        switch self {
        case .saved(let phrase):
            return phrase.displayContexts
        case .generated(let generatedPhrase):
            return generatedPhrase.displayContexts
        }
    }

    var displayCollocations: [Collocation] {
        switch self {
        case .saved(let phrase):
            return phrase.displayCollocations
        case .generated(let generatedPhrase):
            return generatedPhrase.displayCollocations
        }
    }

    var displayOrigin: String {
        switch self {
        case .saved(let phrase):
            return phrase.displayOrigin
        case .generated(let generatedPhrase):
            return generatedPhrase.displayOrigin
        }
    }

    var displayTips: String {
        switch self {
        case .saved(let phrase):
            return phrase.displayTips
        case .generated(let generatedPhrase):
            return generatedPhrase.displayTips
        }
    }

    var displaySimilar: [SimilarPhrase] {
        switch self {
        case .saved(let phrase):
            return phrase.displaySimilar
        case .generated(let generatedPhrase):
            return generatedPhrase.displaySimilar
        }
    }
}
