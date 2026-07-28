//
//  InstantCompositionPlayView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/20.
//

import SwiftUI

struct InstantCompositionPlayView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = InstantCompositionViewModel()
    @State private var flipDegree: Double = 0
    @State private var showingExitAlert: Bool = false
    
    var isFrontVisible: Bool {
        Int(flipDegree / 180) % 2 == 0
    }
    
    let phrase: Phrase
    let settings: CompositionSession.SessionSettings
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                switch viewModel.currentState {
                case .loading:
                    ProgressView("問題生成中...")
                        .scaleEffect(1.2)
                        .tint(.white)
                        .foregroundStyle(.white)
                case .failed:
                    failureView
                case .finished:
                    InstantCompositionResultView(
                        viewModel: viewModel,
                        onDismiss: { dismiss() }
                    )
                    .transition(.opacity)
                case .playing, .evaluating, .showingResult:
                    if let log = viewModel.currentLog {
                        closeButton
                        VStack {
                            Text("\(viewModel.currentQuestionIndex + 1) / \(viewModel.totalQuestionCount)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding(10)
                            
                            ProgressView(
                                value: Float(viewModel.currentQuestionIndex + 1),
                                total: Float(viewModel.totalQuestionCount)
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                        
                        ZStack {
                            if isFrontVisible {
                                CardFrontView(viewModel: viewModel, log: log, flipDegree: $flipDegree)
                            } else {
                                CardBackView(viewModel: viewModel, log: log, flipDegree: $flipDegree)
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y:1, z: 0))
                            }
                        }
                        .rotation3DEffect(
                            .degrees(flipDegree),
                            axis: (x: 0, y: 1, z: 0))
                        .transition(.opacity)
                    }
                }
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
            .onAppear {
                viewModel.loadQuestions(phrase: phrase, settings: settings)
            }
        }
        .alert("終了しますか？", isPresented: $showingExitAlert) {
            Button("キャンセル", role: .cancel) {}
            
            Button("終了する", role: .destructive) {
                dismiss()
            }
        }
        .frame(alignment: .center)
    }
    
    private var closeButton : some View {
        HStack {
            Button {
                showingExitAlert = true
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundStyle(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }

    private var failureView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange)

            Text(viewModel.failureTitle)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }

            Button {
                viewModel.retryFailedOperation()
            } label: {
                Text("もう一度試す")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Button("終了する", role: .destructive) {
                dismiss()
            }
        }
        .padding(24)
        .frame(maxWidth: 360)
    }
}


#Preview("表面 - playing") {
    let settings = CompositionSession.SessionSettings(questionCount: 3, difficulty: .intermediate, scene: SceneType.daily.rawValue, formatLevel: .casual)
    InstantCompositionPlayView(
        phrase: MockPhraseData.makeAKilling,
        settings: settings
    )
}
