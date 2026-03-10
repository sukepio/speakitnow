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
                VStack {
                    HStack {
                        Button {
                            showingExitAlert = true
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(viewModel.currentQuestionIndex + 1) / \(viewModel.totalQuestionCount == 0 ? 5 : viewModel.totalQuestionCount)問目")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(10)
                    
                    ProgressView(
                        value: Float(viewModel.currentQuestionIndex + 1),
                        total: Float(viewModel.totalQuestionCount == 0 ? 5 : viewModel.totalQuestionCount)
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                switch viewModel.currentState {
                case .loading:
                    ProgressView("問題生成中...")
                        .scaleEffect(1.2)
                case .finished:
                    InstantCompositionResultView(
                        viewModel: viewModel,
                        onDismiss: { dismiss() }
                    )
                    .transition(.opacity)
                case .playing, .evaluating, .showingResult:
                    if let log = viewModel.currentLog {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
}


#Preview("表面 - playing") {
    let settings = CompositionSession.SessionSettings(questionCount: 3, difficulty: .intermediate, scene: SceneType.daily.rawValue, formatLevel: .casual)
    InstantCompositionPlayView(
        phrase: MockPhraseData.makeAKilling,
        settings: settings
    )
}

//#Preview("完了画面") {
//    let settings = CompositionSession.SessionSettings(questionCount: 3, difficulty: .intermediate, scene: SceneType.daily.rawValue, formatLevel: .casual)
//    InstantCompositionPlayView(
//        phrase: MockPhraseData.makeAKilling,
//        settings: settings
//    )
//}
