//
//  InstantCompositionViewModel.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/27.
//

import Foundation

enum GameState {
    case loading
    case playing
    case evaluating
    case showingResult
    case finished
}

@MainActor
class InstantCompositionViewModel: ObservableObject {
    @Published var currentState: GameState = .loading
    @Published var currentQuestionIndex: Int = 0
    @Published var logs: [CompositionLog] = [] // n問分のデータ
    
    // 全問題数
    var totalQuestionCount: Int { logs.count }
    
    // 現在の問題データ
    var currentLog: CompositionLog? {
        guard currentQuestionIndex < totalQuestionCount else { return nil }
        return logs[currentQuestionIndex]
    }
    
    // 初期化とモックデータのロード
    func loadQuestions(phrase: Phrase, settings: CompositionSession.SessionSettings) {
        self.currentState = .loading
        
        // TODO: ここにLLMへの問題生成APIリクエストと、Firestore(CompositionSessions)への保存処理を書く
        
        // ▼ 現在はAPIの通信ラグ（1.5秒）をシミュレートしつつモックデータをロード
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.logs = MockCompositionData.generateLogs(count: settings.questionCount)
            self.currentState = .playing
        }
    }
    
    // 回答の送信と添削の取得
    func submitAnswer(userText: String) {
        self.currentState = .evaluating
        logs[currentQuestionIndex].userAnswerEn = userText
        
        // TODO: ここにLLMへの添削APIリクエストと、Firestore(SessionLogs)への逐次保存処理を書く
        
        // ▼ 現在は添削APIの通信ラグ（1.0秒）をシミュレートしつつ固定のフィードバックを返す
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logs[self.currentQuestionIndex].feedback = "文法的には正しいですが、「その場で臨機応変に決めよう」というニュアンスを出すには \"on the fly\" というイディオムが自然です。"
            self.logs[self.currentQuestionIndex].isPerfect = true
            self.logs[self.currentQuestionIndex].otherModelAnserEn = ["I don't know.", "Not that I know of."]
            self.currentState = .showingResult
        }
    }
    
    // 次の問題へ進む
    func nextQuestion() {
        if currentQuestionIndex < totalQuestionCount - 1 {
            currentQuestionIndex += 1
            currentState = .playing
        } else {
            currentState = .finished
        }
    }
}
