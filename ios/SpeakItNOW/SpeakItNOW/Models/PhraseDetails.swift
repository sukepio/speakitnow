//
//  PhraseDetails.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

/// 詳細情報
struct PhraseDetails: Codable, Hashable {
    let detailedMeaning: String
    let contexts: [String]
    let collocations: [Collocation]
    let examples: [Example]
    let origin: String
    let tips: String
    let similar: [SimilarPhrase]
}
