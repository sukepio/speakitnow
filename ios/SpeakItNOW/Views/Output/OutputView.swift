//
//  OutputView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/08.
//

import SwiftUI

struct OutputView: View {
    @State private var selectedPhrase: Phrase? = nil
    @State private var selectedTab = "Conversation"
    let phrase: Phrase
    let source: PhraseDetailSource
    let tabs = ["Conversation", "Writing"]
    
    @Namespace private var animation
    
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                Text("アウトプット")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // 選択フレーズ
                PhraseRow(item: phrase)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedPhrase = phrase
                    }
                
                // タブ
                HStack(spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in
                        Text(tab == "Conversation" ? "ミニ会話" : "瞬間英作文")
                            .font(.system(size: 13, weight: tab == selectedTab ? .semibold : .medium))
                            .foregroundColor(tab == selectedTab ? .black : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background{
                                if tab == selectedTab {
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.white)
                                        .matchedGeometryEffect(id: "TabBackground", in: animation)
                                        .padding(2)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTab = tab
                                }
                            }
                    }
                }
                
                // タブコンテンツエリア
                ZStack {
                    MiniConversationView(
                        conversations: phrase.phraseDetails.conversations
                    )
                    .opacity(selectedTab == "Conversation" ? 1 : 0)
                    .allowsHitTesting(selectedTab == "Conversation")
                    
                    InstantCompositionSettingsView(phrase: phrase)
                        .opacity(selectedTab == "Writing" ? 1 : 0)
                        .allowsHitTesting(selectedTab == "Writing")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .sheet(item: $selectedPhrase) { phrase in
                PhraseDetailView(
                    phrase: phrase,
                    source: .output,
                    onStartOutput: { _, _ in}
                )
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            
        }
    }
}

#Preview {
    OutputView(
        phrase: MockPhraseData.lowKey, source: .myPhrase
    )
}
