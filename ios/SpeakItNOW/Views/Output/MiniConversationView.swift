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
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        configurePlaybackSession()
        
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

        configurePlaybackSession()
        
        let utterance1 = AVSpeechUtterance(string: first)
        utterance1.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance1.postUtteranceDelay = 0.5
        
        let utterance2 = AVSpeechUtterance(string: second)
        utterance2.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance1)
        synthesizer.speak(utterance2)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        try? AVAudioSession.sharedInstance().setActive(
            false,
            options: .notifyOthersOnDeactivation
        )
    }

    private func configurePlaybackSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                .playback,
                mode: .spokenAudio,
                options: .duckOthers
            )
            try audioSession.setActive(true)
        } catch {
            print("音声再生用のオーディオセッション設定に失敗しました。")
        }
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
                            Text(conversation.conversationPair.first.en)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .onTapGesture {
                                    speaker.speak(conversation.conversationPair.first.en)
                                }

                            if isMeaningJpShown {
                                VStack(alignment: .leading, spacing: 6) {
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(height: 1)
                                    Text(conversation.conversationPair.first.ja)
                                        .font(.caption)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                        .contentTransition(.opacity)
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            }
                        }
                        .padding(10)
                        .fixedSize(horizontal: false, vertical: true)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(.spring(response: 0.28, dampingFraction: 0.85), value: isMeaningJpShown)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(conversation.conversationPair.second.en)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .onTapGesture {
                                    speaker.speak(conversation.conversationPair.second.en)
                                }

                            if isMeaningJpShown {
                                VStack(alignment: .leading, spacing: 6) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.8))
                                        .frame(height: 1)
                                    Text(conversation.conversationPair.second.ja)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(nil)
                                        .contentTransition(.opacity)
                                }
                                .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity),
                                        removal: .opacity
                                    )
                                )
                            }
                        }
                        .padding(10)
                        .fixedSize(horizontal: false, vertical: true)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .animation(.spring(response: 0.28, dampingFraction: 0.85), value: isMeaningJpShown)
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
                            first: currentConv.conversationPair.first.en,
                            second: currentConv.conversationPair.second.en
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
        .onDisappear {
            speaker.stop()
        }
    }
}

#Preview {
    MiniConversationView(
        conversations: MockPhraseData.onTheFly.phraseDetails.conversations
    )
}
