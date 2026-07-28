//
//  InstantCompositionHistoryRepository.swift
//  SpeakItNOW
//

import Foundation
import Supabase

final class InstantCompositionHistoryRepository {
    private let supabase = SupabaseProvider.client

    func createSession(
        phrase: Phrase,
        settings: CompositionSession.SessionSettings,
        questions: [CompositionLog]
    ) async throws -> Int {
        let userId = try await AuthenticationService.shared.ensureAuthenticated()
        var outputSessionId: Int?

        do {
            let outputSession: OutputSessionIDDTO = try await supabase
                .from("output_sessions")
                .insert(
                    OutputSessionInsertDTO(
                        user_id: userId,
                        phrase_id: phrase.id,
                        phrase_text: phrase.text
                    )
                )
                .select("id")
                .single()
                .execute()
                .value
            outputSessionId = outputSession.id

            let compositionSession: InstantCompositionSessionIDDTO = try await supabase
                .from("instant_composition_sessions")
                .insert(
                    InstantCompositionSessionInsertDTO(
                        output_session_id: outputSession.id,
                        difficulty: settings.difficulty.rawValue,
                        scene: settings.scene,
                        formal_level: settings.formatLevel.rawValue
                    )
                )
                .select("id")
                .single()
                .execute()
                .value

            let logDTOs = questions.map { log in
                CompositionLogInsertDTO(
                    instant_composition_session_id: compositionSession.id,
                    question_index: log.questionIndex,
                    question_json: CompositionQuestionJSONDTO(
                        id: log.id,
                        questionJa: log.questionJa,
                        modelAnswerEn: log.modelAnswerEn
                    ),
                    answer_json: nil
                )
            }

            if !logDTOs.isEmpty {
                try await supabase
                    .from("composition_logs")
                    .insert(logDTOs)
                    .execute()
            }

            return compositionSession.id
        } catch {
            if let outputSessionId {
                try? await deleteOutputSession(id: outputSessionId)
            }
            throw error
        }
    }

    func saveAnswer(
        compositionSessionId: Int,
        log: CompositionLog
    ) async throws {
        _ = try await AuthenticationService.shared.ensureAuthenticated()
        guard let userAnswerEn = log.userAnswerEn,
              let isPerfect = log.isPerfect else {
            return
        }

        let answer = CompositionAnswerJSONDTO(
            userAnswerEn: userAnswerEn,
            feedback: log.feedback,
            alternativeAnswers: log.otherModelAnserEn ?? [],
            isPerfect: isPerfect
        )

        try await supabase
            .from("composition_logs")
            .update(CompositionLogAnswerUpdateDTO(answer_json: answer))
            .eq("instant_composition_session_id", value: compositionSessionId)
            .eq("question_index", value: log.questionIndex)
            .execute()
    }

    func fetchSessions() async throws -> [InstantCompositionHistorySession] {
        let userId = try await AuthenticationService.shared.ensureAuthenticated()
        let outputSessions: [OutputSessionHistoryDTO] = try await supabase
            .from("output_sessions")
            .select(
                """
                id, phrase_id, phrase_text, created_at,
                instant_composition_sessions(
                    id, difficulty, scene, formal_level, created_at,
                    composition_logs(question_index, question_json, answer_json)
                )
                """
            )
            .eq("user_id", value: userId)
            .order("created_at", ascending: false)
            .execute()
            .value

        return outputSessions.flatMap { outputSession in
            outputSession.instant_composition_sessions.map { session in
                InstantCompositionHistorySession(
                    id: session.id,
                    outputSessionId: outputSession.id,
                    phraseId: outputSession.phrase_id,
                    phraseText: outputSession.phrase_text,
                    difficulty: session.difficulty,
                    scene: session.scene,
                    formalLevel: session.formal_level,
                    createdAt: session.created_at,
                    logs: session.composition_logs
                        .sorted { $0.question_index < $1.question_index }
                        .map { log in
                            InstantCompositionHistoryLog(
                                sessionId: session.id,
                                questionIndex: log.question_index,
                                questionId: log.question_json.id,
                                questionJa: log.question_json.questionJa,
                                modelAnswerEn: log.question_json.modelAnswerEn,
                                userAnswerEn: log.answer_json?.userAnswerEn,
                                feedback: log.answer_json?.feedback,
                                alternativeAnswers: log.answer_json?.alternativeAnswers ?? [],
                                isPerfect: log.answer_json?.isPerfect
                            )
                        }
                )
            }
        }
        .sorted { $0.createdAt > $1.createdAt }
    }

    func deleteSession(_ session: InstantCompositionHistorySession) async throws {
        _ = try await AuthenticationService.shared.ensureAuthenticated()
        try await deleteOutputSession(id: session.outputSessionId)
    }

    private func deleteOutputSession(id: Int) async throws {
        try await supabase
            .from("output_sessions")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
