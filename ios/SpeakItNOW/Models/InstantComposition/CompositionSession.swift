//
//  CompositionSession.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/27.
//

import Foundation

// MARK: - セッション（1回のプレイ全体）
struct CompositionSession: Identifiable, Codable {
    var id: String?
    var basePhraseID: String
    var settings: SessionSettings
    var createdAt: Date
    
    // 設定情報をまとめるサブ構造体
    struct SessionSettings: Codable {
        var questionCount: Int
        var difficulty: Difficulty
        var scene: String
        var formatLevel: FormalLevel
    }
}
