//
//  CardBackView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/21.
//

import SwiftUI

struct CardBackView: View {
    @ObservedObject var viewModel: InstantCompositionViewModel
    var log: CompositionLog
    @Binding var flipDegree: Double
    @StateObject private var speaker = ConversationSpeaker()
    
    var isPerfect: Bool {
        log.isPerfect == true
    }
    
    var isLastQuestion: Bool {
        viewModel.currentQuestionIndex == viewModel.totalQuestionCount - 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // 問題
                    Text(log.questionJa)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                    
                    // ユーザー回答
                    VStack(alignment: .leading) {
                        HStack {
                            Text("あなたの回答")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))

                            Spacer()

                            if isPerfect, let userAnswer = log.userAnswerEn {
                                speechButton(
                                    text: userAnswer,
                                    accessibilityLabel: "あなたの回答を再生"
                                )
                            }
                        }
                        .padding(.bottom, 12)
                        
                        Text(log.userAnswerEn ?? "")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(8)
                    
                    if viewModel.currentState == .evaluating {
                        Spacer()
                        ProgressView("添削中...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        // 見本回答
                        VStack(alignment: .leading) {
                            HStack {
                                Text("回答例")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))

                                Spacer()

                                speechButton(
                                    text: log.modelAnswerEn,
                                    accessibilityLabel: "回答例を再生"
                                )
                            }
                            .padding(.bottom, 12)
                            
                            Text(log.modelAnswerEn)
                                .font(.headline)
                                .foregroundStyle(.green)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(8)
                        
                        // 解説
                        if isPerfect || log.feedback != nil {
                            VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: isPerfect ? "checkmark.circle.fill" : "lightbulb.fill")
                                            .foregroundStyle(.blue)
                                        Text(isPerfect ? "Excellent!" : "ポイント")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.black)
                                    }
                                
                                Text(isPerfect ? "修正はありません。" : (log.feedback ?? ""))
                                    .font(.subheadline)
                                    .foregroundStyle(.black) 
                                    .lineSpacing(4)
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(16)
                            .background(Color.blue.opacity(0.1))
                            .overlay(
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 4),
                                alignment: .leading
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding(.bottom, 24)
            
            VStack {
                // 「次へ」ボタン
                Button {
                    speaker.stop()

                    if isLastQuestion {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            viewModel.nextQuestion()
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            flipDegree += 180
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.nextQuestion()
                        }
                    }
                    
                } label: {
                    Text(isLastQuestion ? "完了" : "次へ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .background(viewModel.currentState == .evaluating ? Color.gray : Color.blue)
                .cornerRadius(20)
                .disabled(viewModel.currentState == .evaluating)
            }
        }
        .padding(24)
        .frame(maxWidth: 360, maxHeight: 700, alignment: .top)
        .background(.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .onDisappear {
            speaker.stop()
        }
    }

    private func speechButton(
        text: String,
        accessibilityLabel: String
    ) -> some View {
        Button {
            speaker.speak(text)
        } label: {
            Image(systemName: "speaker.wave.2.fill")
                .font(.title3)
                .foregroundStyle(.blue)
                .padding(8)
                .background(.white.opacity(0.12))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview("裏面 - 結果表示") {
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.currentState = .showingResult
        return vm
    }()
    
    let mockLog = CompositionLog(
        id: "mock1",
        sessionId: "session1",
        questionIndex: 1,
        questionJa: "その場で決めよう",
        modelAnswerEn: "Let's decide on the fly.",
        userAnswerEn: "Let's decide on the spot.", // ユーザーがこう答えた想定
        feedback: "文法的には正しいですが、「その場で臨機応変に決めよう」というニュアンスを出すには \"on the fly\" というイディオムが自然です。",
        isPerfect: false,
        createdAt: nil
    )
    
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        CardBackView(viewModel: mockVM, log: mockLog, flipDegree: .constant(180.0))
    }
}

#Preview("裏面 - 添削中") {
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.currentState = .evaluating // または .evaluating
        return vm
    }()
    
    let mockLog = CompositionLog(
        id: "mock1",
        sessionId: "session1",
        questionIndex: 1,
        questionJa: "その場で決めよう",
        modelAnswerEn: "Let's decide on the fly.",
        userAnswerEn: "Let's decide on the spot.",
        feedback: nil,
        isPerfect: nil,
        createdAt: nil
    )
    
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        CardBackView(viewModel: mockVM, log: mockLog , flipDegree: .constant(180.0))
    }
}

#Preview("裏面 - 最終質問") {
    let mockLog = CompositionLog(
        id: "mock1",
        sessionId: "session1",
        questionIndex: 0,
        questionJa: "その場で決めよう",
        modelAnswerEn: "Let's decide on the fly.",
        userAnswerEn: "Let's decide on the spot.", // ユーザーがこう答えた想定
        feedback: "文法的には正しいですが、「その場で臨機応変に決めよう」というニュアンスを出すには \"on the fly\" というイディオムが自然です。",
        isPerfect: false,
        createdAt: nil
    )
    
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.currentState = .showingResult
        vm.currentQuestionIndex = 0
        vm.logs = [mockLog]
        return vm
    }()
    
    
    
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        CardBackView(viewModel: mockVM, log: mockLog, flipDegree: .constant(180.0))
    }
}

#Preview("裏面 - パーフェクト（最後の問題）") {
    let mockLog = CompositionLog(
        id: "mock3",
        sessionId: "session1",
        questionIndex: 4,
        questionJa: "その場で決めよう",
        modelAnswerEn: "Let's decide on the fly.",
        userAnswerEn: "Let's decide on the fly.",
        feedback: nil,
        isPerfect: true, // ★ パーフェクトのパターン（緑のUIになるかテスト）
        createdAt: nil
    )
    
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.currentState = .showingResult
        vm.currentQuestionIndex = 4
        return vm
    }()
    
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        CardBackView(viewModel: mockVM, log: mockLog, flipDegree: .constant(180.0))
    }
}
