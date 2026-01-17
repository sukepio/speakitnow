//
//  Phrase.swift
//  
//
//  Created by 助名直人 on 2026/01/15.
//
import Foundation

/// 画面共通で扱うフレーズ（Homeでもdetailsを事前に保持する前提）
struct Phrase: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let meaningJa: String
    let isRecommended: Bool
    let details: PhraseDetails

    // 将来の拡張（必要になったら使う）
    var tags: [String]?
    var isSaved: Bool?
    var difficulty: Difficulty?
}

enum Difficulty: String, Codable, Hashable {
    case easy
    case medium
    case hard
}
