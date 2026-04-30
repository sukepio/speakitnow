//
//  SimilarPhraseDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/02.
//

import Foundation

struct SimilarPhraseDTO: Decodable {
    let id: String
    let phrase: String
    let meaning_ja: String

    // 将来の拡張（必要になったら使う）
    var nuance: String?
    var formality: FormalityDTO?
}

enum FormalityDTO: String, Codable, Hashable {
    case casual
    case neutral
    case formal
}
