//
//  InstantCompositionSettingsView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/07/16.
//

import SwiftUI

struct InstantCompositionSettingsScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var questionCount: Int
    @State private var selectedDifficulty: Difficulty
    @State private var selectedScene: SceneType
    @State private var selectedFormalLevel: FormalLevel
    @State private var isPlayScreenShown: Bool
    
    let phrase: Phrase
    
    init(
        questionCount: Int,
        selectedDifficulty: Difficulty,
        selectedScene: SceneType,
        selectedFormalLevel: FormalLevel,
        isPlayScreenShown: Bool,
        phrase: Phrase
    ) {
        _questionCount = State(initialValue: questionCount)
        _selectedDifficulty = State(initialValue: selectedDifficulty)
        _selectedScene = State(initialValue: selectedScene)
        _selectedFormalLevel = State(initialValue: selectedFormalLevel)
        _isPlayScreenShown = State(initialValue: isPlayScreenShown)
        self.phrase = phrase
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("フレーズ") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(phrase.text)
                            .font(.headline)
                        Text(phrase.meaningJa)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("問題数") {
                    Stepper(value: $questionCount, in: 1...20, step: 1) {
                        Text("\(questionCount) 問")
                    }
                }
                
                Section("難易度") {
                    Picker("難易度", selection: $selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Difficulty.allCases, id: \.self) { level in
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(level.rawValue)
                                        .fontWeight(.semibold)
                                    Text(level.cefrLevel)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.blue)
                                }
                                Text(level.levelDescription)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(
                                selectedDifficulty == level
                                    ? Color.blue.opacity(0.1)
                                    : Color.clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                
                Section("シーン") {
                    Picker("", selection: $selectedScene) {
                        ForEach(SceneType.allCases, id: \.self) { scene in
                            Text(scene.rawValue).tag(scene)
                        }
                    }
                }
                
                Section("フォーマルさ") {
                    Picker("フォーマルさ", selection: $selectedFormalLevel) {
                        ForEach(FormalLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Button {
                    isPlayScreenShown = true
                } label: {
                    Text("この設定で始める")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(.bar)
                .accessibilityLabel("瞬間英作文を開始")
                .accessibilityHint("選択した設定でプレイ画面を開きます")
            }
            .navigationTitle("瞬間英作文の設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .fullScreenCover(isPresented: $isPlayScreenShown) {
            let settings = CompositionSession.SessionSettings(
                questionCount: questionCount,
                difficulty: selectedDifficulty,
                scene: selectedScene.rawValue,
                formatLevel: selectedFormalLevel
            )
            InstantCompositionPlayView(
                phrase: phrase,
                settings: settings
            )
        }
    }
}

#Preview {
    InstantCompositionSettingsScreen(
        questionCount: 5,
        selectedDifficulty: Difficulty.beginner,
        selectedScene: SceneType.daily,
        selectedFormalLevel: FormalLevel.casual,
        isPlayScreenShown: false,
        phrase: MockPhraseData.lowKey
    )
}
