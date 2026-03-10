//
//  MockCompositionData.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/27.
//

import Foundation

// MARK: - 開発用のモックデータ生成器
struct MockCompositionData {
    static func generateLogs(count: Int, sessionId: String = UUID().uuidString) -> [CompositionLog] {
        var mockLogs: [CompositionLog] = []
        let dummyQuestions = [
            ("その場で決めよう", "Let's decide on the fly."),
            ("彼は口が堅い", "He is tight-lipped."),
            ("予定を前倒しできますか？", "Can we move the schedule up?"),
            ("それは初耳です", "That's news to me."),
            ("一か八かやってみよう", "Let's take a chance.")
        ]
        
        for i in 0..<count {
            let question = dummyQuestions[i % dummyQuestions.count]
            let log = CompositionLog(
                id: UUID().uuidString,
                sessionId: sessionId,
                questionIndex: i + 1,
                questionJa: question.0, // 日本語の問題
                modelAnswerEn: question.1, // 模範解答
                userAnswerEn: nil,
                feedback: nil,
                otherModelAnserEn: ["I don't know.", "Not that I know of."],
                isPerfect: nil,
                createdAt: nil
            )
            mockLogs.append(log)
        }
        
        return mockLogs
    }
}
