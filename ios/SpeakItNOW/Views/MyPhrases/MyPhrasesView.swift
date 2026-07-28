//
//  MyPhrasesView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct MyPhrasesView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    var myPhrases: [Phrase] { phraseStore.myPhrases }
    @State private var selectedPhrase: Phrase? = nil
    @State private var path: [DetailRoute] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("Myフレーズ帳")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    content
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(item: $selectedPhrase) { phrase in
            NavigationStack(path: $path) {
                PhraseDetailView(
                    phrase: phrase,
                    source: .myPhrase,
                    onStartOutput: { phrase, source in
                        path.append(.output(pharase: phrase, source: source))
                    }
                )
                .navigationDestination(for: DetailRoute.self) { route in
                    switch route {
                    case.output(let phrase, let source):
                        OutputView(phrase: phrase, source: source)
                    }
                }
            }
        }
        .alert("Myフレーズ帳を更新できませんでした", isPresented: errorBinding) {
            Button("閉じる", role: .cancel) {}
        } message: {
            Text(phraseStore.errorMessage ?? "")
        }
    }

    @ViewBuilder
    private var content: some View {
        if myPhrases.isEmpty {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "bookmark")
                    .font(.system(size: 52))
                    .foregroundStyle(.white.opacity(0.45))
                Text("まだフレーズがありません")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("気になる英語表現を追加すると、ここに表示されます。")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.65))
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding(.horizontal, 32)
        } else {
            List {
                ForEach(myPhrases) { phrase in
                    PhraseRow(item: phrase)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPhrase = phrase
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    await phraseStore.removeMyPhrase(phrase)
                                }
                            } label: {
                                Label("削除", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .refreshable {
                await phraseStore.loadMyPhrases()
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { phraseStore.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    phraseStore.errorMessage = nil
                }
            }
        )
    }
}

#Preview {
    MyPhrasesView()
        .environmentObject(PhraseStore())
}
