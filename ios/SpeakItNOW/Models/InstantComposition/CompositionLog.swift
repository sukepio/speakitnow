//
//  CompositionLog.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/27.
//

import Foundation

// MARK: - ログ（1問ごとの履歴）
struct CompositionLog: Identifiable, Codable {
    var id: String?
    var sessionId: String
    var questionIndex: Int
    
    // 問題データ
    var questionJa: String
    var modelAnswerEn: String
    
    // ユーザーの回答と添削結果
    var userAnswerEn: String? = nil
    var feedback: String? = nil
    var otherModelAnserEn: [String]? = nil
    var isPerfect: Bool? = nil
    var createdAt: Date? = nil
}
