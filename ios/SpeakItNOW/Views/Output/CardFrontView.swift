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
    @Binding var isFlipped : Bool
    @State private var userText : String = ""
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack(spacing: 16) {
            Text(log.questionJa)
                .font(.title3.bold())
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .padding(.vertical, 60)
            
            TextEditor(text: speechRecognizer.recognizedText.isEmpty && !speechRecognizer.isRecording ? $userText : $speechRecognizer.recognizedText)
                .padding(16)
                .frame(maxWidth: 280, maxHeight: 160)
                .scrollContentBackground(Visibility.hidden)
                .background(Color.black.opacity(0.8))
                .cornerRadius(8)
            
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
                        isFlipped = true
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
        .frame(maxWidth: 360, maxHeight: 600, alignment: .top)
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
        CardFrontView(viewModel: mockVM, log: mockLog, isFlipped: .constant(false))
    }
}
