//
//  Difficulty.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/20.
//

import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "初級"
    case intermediate = "中級"
    case advanced = "上級"

    var cefrLevel: String {
        switch self {
        case .beginner:
            return "CEFR A1〜A2"
        case .intermediate:
            return "CEFR B1"
        case .advanced:
            return "CEFR B2以上"
        }
    }

    var levelDescription: String {
        switch self {
        case .beginner:
            return "基本語彙と短い単文を中心に出題します。"
        case .intermediate:
            return "理由や状況を加えた日常的な英文を出題します。"
        case .advanced:
            return "複文や自然な語彙を含む実践的な英文を出題します。"
        }
    }

    var displayName: String {
        "\(rawValue)（\(cefrLevel)）"
    }
}
