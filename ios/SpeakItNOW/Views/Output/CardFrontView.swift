//
//  CardFrontView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/21.
//

import SwiftUI

struct CardFrontView: View {
    @ObservedObject var viewModel: InstantCompositionViewModel
    var log: CompositionLog
    @Binding var flipDegree : Double
    @State private var userText : String = ""
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text(log.questionJa)
                .font(.title3.bold())
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .padding(.vertical, 60)
            
            TextField("", text: speechRecognizer.recognizedText.isEmpty && !speechRecognizer.isRecording ? $userText : $speechRecognizer.recognizedText, axis: .vertical)
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: 160, alignment: .topLeading)
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }
                .background(Color.black.opacity(0.8))
                .foregroundStyle(.white)
                .cornerRadius(8)
                .submitLabel(.done)
                .focused($isFocused)
                .onChange(of: userText) { oldValue, newValue in
                        // ★ 最後の入力が「改行」だったら
                        if newValue.hasSuffix("\n") {
                            // 1. 改行文字を取り除く
                            userText = String(newValue.dropLast())
                            
                            // 2. フォーカスを外す（＝キーボードが閉じる）
                            isFocused = false
                        }
                }
            
            HStack(spacing: 30) {
                // リセットボタン
                Button {
                    userText = ""
                    speechRecognizer.recognizedText = ""
                } label: {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                        .font(.system(size: 40))
                }
                .disabled(userText.isEmpty && speechRecognizer.recognizedText.isEmpty ? true : false)
                
                // 録音ボタン
                Button {
                    speechRecognizer.toggleRecording()
                } label: {
                    Image(systemName: speechRecognizer.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(speechRecognizer.isRecording ? .red : .blue)
                }
                
                // 送信ボタン
                Button {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        flipDegree += 180
                    }
                    
                    viewModel.submitAnswer(userText: speechRecognizer.recognizedText.isEmpty ? userText : speechRecognizer.recognizedText)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 40))
                }
                .disabled(userText.isEmpty && speechRecognizer.recognizedText.isEmpty ? true : false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .padding(24)
        .frame(maxWidth: 360, maxHeight: 700, alignment: .top)
        .background(.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
        
#Preview("表面 (CardFrontView)") {
    let mockVM: InstantCompositionViewModel = {
            let vm = InstantCompositionViewModel()
            vm.currentState = .playing
            return vm
    }()
    
    let mockLog = CompositionLog(
        id: "mock1",
        sessionId: "session1",
        questionIndex: 1,
        questionJa: "その場で決めよう",
        modelAnswerEn: "Let's decide on the fly."
    )
    
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        CardFrontView(viewModel: mockVM, log: mockLog, flipDegree: .constant(360.0))
    }
}
