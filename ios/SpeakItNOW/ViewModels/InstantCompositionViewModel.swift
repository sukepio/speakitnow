//
//  InstantCompositionViewModel.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/27.
//

import Foundation

enum GameState: Equatable {
    case loading
    case playing
    case evaluating
    case showingResult
    case failed
    case finished
}

@MainActor
final class InstantCompositionViewModel: ObservableObject {
    enum FailedOperation {
        case questionGeneration
        case answerEvaluation
        case sessionPersistence
        case answerPersistence
    }

    @Published var currentState: GameState = .loading
    @Published var currentQuestionIndex: Int = 0
    @Published var logs: [CompositionLog] = []
    @Published var errorMessage: String?

    var totalQuestionCount: Int { logs.count }

    var currentLog: CompositionLog? {
        guard logs.indices.contains(currentQuestionIndex) else { return nil }
        return logs[currentQuestionIndex]
    }

    var failureTitle: String {
        switch failedOperation {
        case .questionGeneration:
            return "問題を生成できませんでした"
        case .answerEvaluation:
            return "回答を添削できませんでした"
        case .sessionPersistence, .answerPersistence:
            return "履歴を保存できませんでした"
        case nil:
            return "エラーが発生しました"
        }
    }

    private let llmService: any LLMServiceProtocol
    private let historyRepository: InstantCompositionHistoryRepository
    private var phrase: Phrase?
    private var settings: CompositionSession.SessionSettings?
    private var compositionSessionId: Int?
    private var pendingAnswerIndex: Int?
    private var failedOperation: FailedOperation?
    private var requestTask: Task<Void, Never>?

    init(
        llmService: any LLMServiceProtocol = LLMProvider.shared,
        historyRepository: InstantCompositionHistoryRepository = InstantCompositionHistoryRepository()
    ) {
        self.llmService = llmService
        self.historyRepository = historyRepository
    }

    deinit {
        requestTask?.cancel()
    }

    func loadQuestions(phrase: Phrase, settings: CompositionSession.SessionSettings) {
        self.phrase = phrase
        self.settings = settings
        currentQuestionIndex = 0
        logs = []
        compositionSessionId = nil
        pendingAnswerIndex = nil
        generateQuestions()
    }

    func submitAnswer(userText: String) {
        guard logs.indices.contains(currentQuestionIndex) else { return }

        let trimmedAnswer = userText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAnswer.isEmpty else { return }

        logs[currentQuestionIndex].userAnswerEn = trimmedAnswer
        evaluateCurrentAnswer()
    }

    func retryFailedOperation() {
        switch failedOperation {
        case .questionGeneration:
            generateQuestions()
        case .answerEvaluation:
            evaluateCurrentAnswer()
        case .sessionPersistence:
            retrySessionPersistence()
        case .answerPersistence:
            retryAnswerPersistence()
        case nil:
            break
        }
    }

    func nextQuestion() {
        guard currentState == .showingResult else { return }

        if currentQuestionIndex < totalQuestionCount - 1 {
            currentQuestionIndex += 1
            currentState = .playing
        } else {
            currentState = .finished
        }
    }

    private func generateQuestions() {
        guard let phrase, let settings else { return }

        requestTask?.cancel()
        currentState = .loading
        errorMessage = nil
        failedOperation = nil

        let request = InstantCompositionGenerationRequest(
            phraseText: phrase.text,
            phraseMeaning: phrase.meaningJa,
            questionCount: settings.questionCount,
            difficulty: settings.difficulty.rawValue,
            scene: settings.scene,
            formalLevel: settings.formatLevel.rawValue,
            locale: Locale.current.identifier
        )

        requestTask = Task { [weak self] in
            guard let self else { return }
            do {
                let questions = try await llmService.generateInstantComposition(request: request)
                guard !Task.isCancelled else { return }

                let sessionId = UUID().uuidString
                logs = questions.enumerated().map { index, question in
                    CompositionLog(
                        id: question.id,
                        sessionId: sessionId,
                        questionIndex: index,
                        questionJa: question.questionJa,
                        modelAnswerEn: question.modelAnswerEn
                    )
                }
                currentState = .playing
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                failedOperation = .questionGeneration
                errorMessage = error.localizedDescription
                currentState = .failed
            }
        }
    }

    private func evaluateCurrentAnswer() {
        guard let phrase,
              let settings,
              logs.indices.contains(currentQuestionIndex),
              let userAnswer = logs[currentQuestionIndex].userAnswerEn else {
            return
        }

        requestTask?.cancel()
        currentState = .evaluating
        errorMessage = nil
        failedOperation = nil

        let evaluatedIndex = currentQuestionIndex
        let log = logs[evaluatedIndex]
        let request = InstantCompositionEvaluationRequest(
            phraseText: phrase.text,
            phraseMeaning: phrase.meaningJa,
            questionJa: log.questionJa,
            modelAnswerEn: log.modelAnswerEn,
            userAnswerEn: userAnswer,
            difficulty: settings.difficulty.rawValue,
            locale: Locale.current.identifier
        )

        requestTask = Task { [weak self] in
            guard let self else { return }
            do {
                let evaluation = try await llmService.evaluateInstantCompositionAnswer(request: request)
                guard !Task.isCancelled, logs.indices.contains(evaluatedIndex) else { return }

                logs[evaluatedIndex].feedback = evaluation.feedback
                logs[evaluatedIndex].otherModelAnserEn = evaluation.alternativeAnswers
                logs[evaluatedIndex].isPerfect = evaluation.isPerfect
                pendingAnswerIndex = evaluatedIndex
                await persistAnswer(at: evaluatedIndex)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                failedOperation = .answerEvaluation
                errorMessage = error.localizedDescription
                currentState = .failed
            }
        }
    }

    private func persistAnswer(at index: Int) async {
        guard logs.indices.contains(index),
              let phrase,
              let settings else { return }

        do {
            if compositionSessionId == nil {
                compositionSessionId = try await historyRepository.createSession(
                    phrase: phrase,
                    settings: settings,
                    questions: logs
                )
            }

            guard let compositionSessionId else { return }
            try await historyRepository.saveAnswer(
                compositionSessionId: compositionSessionId,
                log: logs[index]
            )
            pendingAnswerIndex = nil
            failedOperation = nil
            errorMessage = nil
            currentState = .showingResult
        } catch {
            guard !Task.isCancelled else { return }
            failedOperation = compositionSessionId == nil
                ? .sessionPersistence
                : .answerPersistence
            errorMessage = error.localizedDescription
            currentState = .failed
        }
    }

    private func retrySessionPersistence() {
        guard let pendingAnswerIndex else { return }

        requestTask?.cancel()
        currentState = .evaluating
        errorMessage = nil

        requestTask = Task { [weak self] in
            await self?.persistAnswer(at: pendingAnswerIndex)
        }
    }

    private func retryAnswerPersistence() {
        guard let pendingAnswerIndex else { return }

        requestTask?.cancel()
        currentState = .evaluating
        errorMessage = nil

        requestTask = Task { [weak self] in
            await self?.persistAnswer(at: pendingAnswerIndex)
        }
    }
}
