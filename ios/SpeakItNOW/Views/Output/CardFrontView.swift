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
    
    private var isRecording: Bool {
        speechRecognizer.state == .recording
    }
    
    private var trimmedUserText: String {
        userText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var canSubmit: Bool {
        !trimmedUserText.isEmpty && speechRecognizer.state == .idle
    }
    
    private var canReset: Bool {
        !userText.isEmpty && speechRecognizer.state == .idle
    }
    
    private var canRecord: Bool {
        !isFocused && speechRecognizer.state != .processing
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(log.questionJa)
                .font(.title3.bold())
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .padding(.vertical, 60)
            
            TextField("", text: $userText, axis: .vertical)
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
                .onChange(of: userText) { _, newValue in
                        if newValue.hasSuffix("\n") {
                            userText = String(newValue.dropLast())
                            isFocused = false
                        }
                }
                .onChange(of: speechRecognizer.state) { _, state in
                    if state == .idle {
                        mergeSpeechToText()
                    }
                }
            
            HStack(spacing: 30) {
                // リセットボタン
                Button {
                    userText = ""
                    speechRecognizer.clearRecognizedText()
                } label: {
                    Image(systemName: "arrow.trianglehead.counterclockwise")
                        .font(.system(size: 40))
                }
                .disabled(!canReset)
                
                // 録音ボタン
                Button {
                    speechRecognizer.toggleRecording()
                } label: {
                    Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(isRecording ? .red : .blue)
                }
                .disabled(!canRecord)
                .opacity(canRecord ? 1 : 0.2)
                
                // 送信ボタン
                Button {
                    isFocused = false
                    withAnimation(.easeInOut(duration: 0.6)) {
                        flipDegree += 180
                    }
                    viewModel.submitAnswer(userText: trimmedUserText)
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 40))
                }
                .rotationEffect(Angle(degrees: 45))
                .disabled(!canSubmit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .padding(24)
        .frame(maxWidth: 360, maxHeight: 700, alignment: .top)
        .background(.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func mergeSpeechToText() {
        let recognized = speechRecognizer.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !recognized.isEmpty else { return }
        
        let prefix = userText.isEmpty || userText.hasSuffix(" ") ? "" : " "
        userText += prefix + recognized
        speechRecognizer.clearRecognizedText()
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
