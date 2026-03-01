//
//  InstantCompositionSettingsView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/19.
//

import SwiftUI

struct InstantCompositionSettingsView: View {
    @State private var questionCount: Int = 5
    @State private var selectedDifficulty: Difficulty = .intermediate
    @State private var selectedScene: SceneType = .daily
    @State private var selectedFormalLevel: FormalLevel = .casual
    @State private var isPlayScreenShown: Bool = false
    let phrase: Phrase
    
    var body: some View {
        VStack(spacing: 0) {
            Form {
                Picker("回数", selection: $questionCount) {
                    ForEach(1...10, id: \.self) { i in
                        Text("\(i)回")
                    }
                }
                Picker("難易度", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                Picker("シーン", selection: $selectedScene) {
                    ForEach(SceneType.allCases, id: \.self) { scene in
                        Text(scene.rawValue).tag(scene)
                    }
                }
                
                Picker("フォーマル度", selection: $selectedFormalLevel) {
                    ForEach(FormalLevel.allCases, id: \.self) { formalLevel in
                        Text(formalLevel.rawValue).tag(formalLevel)
                    }
                }
                .pickerStyle(.segmented)
            }
            .scrollContentBackground(.hidden)
            
            VStack {
                Button {
                    isPlayScreenShown.toggle()
                } label: {
                    Text("スタート")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 16)
                        .foregroundStyle(.white)
                }
                .background(Color.blue)
                .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .padding(.top, 16)
        }
        .fullScreenCover(isPresented: $isPlayScreenShown) {
            let settings = CompositionSession.SessionSettings(
                questionCount: questionCount,
                difficulty: selectedDifficulty,
                scene: selectedScene.rawValue,
                formatLevel: selectedFormalLevel
            )
            
            InstantCompositionPlayView(phrase: phrase, settings: settings)
        }
    }
}

#Preview {
    InstantCompositionSettingsView(phrase: MockPhraseData.makeAKilling)
}
