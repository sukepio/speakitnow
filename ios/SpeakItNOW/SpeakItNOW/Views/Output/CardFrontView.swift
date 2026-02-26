//
//  CardFrontView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/21.
//

import SwiftUI

struct CardFrontView: View {
    @Binding var isFliped : Bool
    @State private var userText : String = ""
    @StateObject private var speechRecognizer = SpeechRecognizer()
    
    var body: some View {
        VStack {
            Text("その場で決めよう")
                .font(.headline)
                .foregroundStyle(.black)
            
            TextEditor(text: speechRecognizer.recognizedText.isEmpty && !speechRecognizer.isRecording ? $userText : $speechRecognizer.recognizedText)
                .frame(width: 280, height: 160)
                .scrollContentBackground(Visibility.hidden)
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
            
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
                        isFliped = true
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 40))
                }
                .disabled(userText.isEmpty && speechRecognizer.recognizedText.isEmpty ? true : false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .padding(20)
        .frame(width: 320, height: 480, alignment: .top)
        .background(.white)
        .cornerRadius(20)
    }
}
        
#Preview {
    CardFrontView(isFliped: .constant(true))
}
