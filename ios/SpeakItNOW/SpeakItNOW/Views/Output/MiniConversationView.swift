//
//  MiniConversationView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/17.
//

import SwiftUI
import AVFoundation

class ConversationSpeaker: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(_ text: String, language: String = "en-US") {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        
        synthesizer.speak(utterance)
    }
    
    func speackConversation(first: String, second: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance1 = AVSpeechUtterance(string: first)
        utterance1.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance1.postUtteranceDelay = 0.5
        
        let utterance2 = AVSpeechUtterance(string: second)
        utterance2.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance1)
        synthesizer.speak(utterance2)
    }
}

struct MiniConversationView: View {
    @State private var selectedConversationNo = 0
    @State private var isMeaningJpShown: Bool = false
    @StateObject private var speaker = ConversationSpeaker()
    let conversations: [Conversation]
    
    var body: some View {
        VStack {
            TabView(selection: $selectedConversationNo) {
                ForEach(Array(conversations.enumerated()), id: \.offset) { index, conversation in
                    VStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(conversation.conversation.first.en)
                                .onTapGesture {
                                    speaker.speak(conversation.conversation.first.en)
                                }
                            
                            if isMeaningJpShown {
                                Rectangle()
                                    .fill(Color.secondary.opacity(0.3))
                                    .frame(height: 1)
                                Text(conversation.conversation.first.ja)
                                    .font(.caption)
                            }
                        }
                        .padding(10)
                        .fixedSize(horizontal: true, vertical: false)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(conversation.conversation.second.en)
                                .foregroundColor(.white)
                                .onTapGesture {
                                    speaker.speak(conversation.conversation.second.en)
                                }
                            
                            if isMeaningJpShown {
                                Rectangle()
                                    .fill(Color.white.opacity(0.8))
                                    .frame(height: 1)
                                
                                Text(conversation.conversation.second.ja)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(10)
                        .fixedSize(horizontal: true, vertical: false)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
            
            // 再生ボタン
            ZStack() {
                Button {
                    withAnimation {
                        isMeaningJpShown.toggle()
                    }
                } label: {
                    Image(systemName: "translate")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            isMeaningJpShown ? AnyShapeStyle(.primary) : AnyShapeStyle(.gray),
                            .primary
                        )
                        
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    if conversations.indices.contains(selectedConversationNo) {
                        let currentConv = conversations[selectedConversationNo]
                        
                        speaker.speackConversation(
                            first: currentConv.conversation.first.en,
                            second: currentConv.conversation.second.en
                        )
                    }
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.white, .primary)
                }
                
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MiniConversationView(
        conversations: MockPhraseData.onTheFly.details.conversations
    )
}
