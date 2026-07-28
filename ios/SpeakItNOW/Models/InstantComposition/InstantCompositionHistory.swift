//
//  InstantCompositionHistory.swift
//  SpeakItNOW
//

import Foundation

struct InstantCompositionHistorySession: Identifiable, Hashable {
    let id: Int
    let outputSessionId: Int
    let phraseId: Int
    let phraseText: String
    let difficulty: String
    let scene: String
    let formalLevel: String
    let createdAt: Date
    let logs: [InstantCompositionHistoryLog]

    var answeredCount: Int {
        logs.filter(\.isAnswered).count
    }

    var perfectCount: Int {
        logs.filter { $0.isPerfect == true }.count
    }

    var isCompleted: Bool {
        !logs.isEmpty && answeredCount == logs.count
    }
}

struct InstantCompositionHistoryLog: Identifiable, Hashable {
    var id: String { "\(sessionId)-\(questionIndex)" }

    let sessionId: Int
    let questionIndex: Int
    let questionId: String?
    let questionJa: String
    let modelAnswerEn: String
    let userAnswerEn: String?
    let feedback: String?
    let alternativeAnswers: [String]
    let isPerfect: Bool?

    var isAnswered: Bool {
        userAnswerEn != nil && isPerfect != nil
    }
}
