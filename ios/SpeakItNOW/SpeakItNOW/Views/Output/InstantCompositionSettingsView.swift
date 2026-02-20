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
    
    var body: some View {
        NavigationStack {
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
                
                Section {
                    Button {
                        isPlayScreenShown.toggle()
                    } label: {
                        Text("スタート")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.blue)
                }
            }
            .fullScreenCover(isPresented: $isPlayScreenShown) {
                Text("一回目")
            }
        }
    }
}

#Preview {
    InstantCompositionSettingsView()
}
