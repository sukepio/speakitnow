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
    @Binding var isFlipped: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // 問題
                    Text(log.questionJa)
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    // ユーザー回答
                    VStack(alignment: .leading) {
                        Text("あなたの回答")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
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
                            Text("より自然な表現")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
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
                        if let feedback = log.feedback {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundStyle(.blue) // 薄い青背景に合わせてアイコンも青に
                                    Text("ポイント")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.black) // 薄い背景に合わせて文字を黒に
                                }
                                
                                Text(feedback)
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
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isFlipped = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.nextQuestion()
                    }
                    
                } label: {
                    Text("次へ")
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
    }
}

#Preview("裏面 - 結果表示") {
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.currentState = .showingResult // または .evaluating
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
        CardBackView(viewModel: mockVM, log: mockLog, isFlipped: .constant(true))
    }
}

#Preview("裏面 - 添削中") {
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.currentState = .showingResult // または .evaluating
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
        CardBackView(viewModel: mockVM, log: mockLog, isFlipped: .constant(true))
    }
}
