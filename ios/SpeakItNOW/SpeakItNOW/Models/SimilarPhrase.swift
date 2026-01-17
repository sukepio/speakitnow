//
//  SimilarPhrase.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

struct SimilarPhrase: Identifiable, Codable, Hashable {
    let id: String
    let phrase: String
    let meaningJa: String

    // 将来の拡張（必要になったら使う）
    var nuance: String?
    var formality: Formality?
}

enum Formality: String, Codable, Hashable {
    case casual
    case neutral
    case formal
}
