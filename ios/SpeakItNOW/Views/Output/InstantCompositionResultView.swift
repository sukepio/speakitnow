//
//  InstantCompositionResultView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/04.
//

import SwiftUI

struct InstantCompositionResultView: View {
    @ObservedObject var viewModel: InstantCompositionViewModel
    var onDismiss: () -> Void
    
    var perfectCount: Int {
        viewModel.logs.filter { $0.isPerfect == true }.count
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("スコア： \(perfectCount) / \(viewModel.logs.count)")
                    .font(.title)
                    .foregroundStyle(.white)
                Text("🎉 お疲れ様でした！")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.logs) { log in
                            // ここに各問題の振り返りUIを作っていく
                            ResultRowView(log: log)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                
                VStack {
                    Button {
                        onDismiss()
                    } label: {
                        Text("終了して戻る")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                        
                    }
                    .background(.blue)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

struct ResultRowView: View {
    var log: CompositionLog
    
    var isPerfect: Bool {
        log.isPerfect == true
    }
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 問題文とアイコン
            HStack (alignment: .top){
                Image(systemName: isPerfect ? "checkmark.circle.fill" : "pencil.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isPerfect ? .green : .orange)
                
                Text(log.questionJa)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            // 自分の回答
            VStack(alignment: .leading, spacing: 4) {
                Text("あなたの回答")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text(log.userAnswerEn ?? "")
                    .font(.subheadline)
                    .foregroundStyle(isPerfect ? .white : .orange)
            }
            
            // 回答例
            VStack(alignment: .leading, spacing: 4) {
                Text("回答例")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text(log.modelAnswerEn)
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
            
            VStack() {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray)
                        .rotationEffect(.degrees(isExpanded ? 0 : 180))
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            if isExpanded {
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                VStack(alignment: .leading, spacing: 4) {
                    if isPerfect {
                        Text("他の表現例")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        VStack(alignment: .leading) {
                            ForEach(log.otherModelAnserEn ?? [], id: \.self){ otherModelAnswer in
                                    Text("・\(otherModelAnswer)")
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                            }
                        }
                    } else {
                        Text("解説")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Text(log.feedback ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                    }
                    
                }
            } 
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.1))
        .cornerRadius(16)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
    }
}

#Preview {
    let mockVM: InstantCompositionViewModel = {
        let vm = InstantCompositionViewModel()
        vm.logs = [
            CompositionLog(
                id: "1", sessionId: "s1", questionIndex: 0,
                questionJa: "その場で決めよう",
                modelAnswerEn: "Let's decide on the fly.",
                userAnswerEn: "Let's decide on the fly.",
                feedback: nil,
                otherModelAnserEn: ["I don't know.", "Not that I know of."],
                isPerfect: true, createdAt: nil
            ),
            CompositionLog(
                id: "2", sessionId: "s1", questionIndex: 1,
                questionJa: "とりあえずビールで",
                modelAnswerEn: "I'll have a beer for now.",
                userAnswerEn: "I want beer first.",
                feedback: "もう少し丁寧な表現が良いでしょう。", isPerfect: false, createdAt: nil
            )
        ]
        return vm
    }()
    
    InstantCompositionResultView(viewModel: mockVM, onDismiss: {})
}
