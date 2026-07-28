//
//  InstantCompositionHistoryDTO.swift
//  SpeakItNOW
//

import Foundation

struct OutputSessionInsertDTO: Encodable {
    let user_id: UUID
    let phrase_id: Int
    let phrase_text: String
}

struct OutputSessionIDDTO: Decodable {
    let id: Int
}

struct InstantCompositionSessionInsertDTO: Encodable {
    let output_session_id: Int
    let difficulty: String
    let scene: String
    let formal_level: String
}

struct InstantCompositionSessionIDDTO: Decodable {
    let id: Int
}

struct CompositionQuestionJSONDTO: Codable {
    let id: String?
    let questionJa: String
    let modelAnswerEn: String
}

struct CompositionAnswerJSONDTO: Codable {
    let userAnswerEn: String
    let feedback: String?
    let alternativeAnswers: [String]
    let isPerfect: Bool
}

struct CompositionLogInsertDTO: Encodable {
    let instant_composition_session_id: Int
    let question_index: Int
    let question_json: CompositionQuestionJSONDTO
    let answer_json: CompositionAnswerJSONDTO?
}

struct CompositionLogAnswerUpdateDTO: Encodable {
    let answer_json: CompositionAnswerJSONDTO
}

struct OutputSessionHistoryDTO: Decodable {
    let id: Int
    let phrase_id: Int
    let phrase_text: String
    let created_at: Date
    let instant_composition_sessions: [InstantCompositionSessionHistoryDTO]
}

struct InstantCompositionSessionHistoryDTO: Decodable {
    let id: Int
    let difficulty: String
    let scene: String
    let formal_level: String
    let created_at: Date
    let composition_logs: [CompositionLogHistoryDTO]
}

struct CompositionLogHistoryDTO: Decodable {
    let question_index: Int
    let question_json: CompositionQuestionJSONDTO
    let answer_json: CompositionAnswerJSONDTO?
}
