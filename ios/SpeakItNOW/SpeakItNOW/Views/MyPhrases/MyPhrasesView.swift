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
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                Text("Myフレーズ帳")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
//                VStack(alignment: .leading, spacing: 12) {
                  List {
                    ForEach(myPhrases) { phrase in
                        PhraseRow(phrase: phrase)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPhrase = phrase
                            }
                            .swipeActions {
                                Button(role: .destructive) { phraseStore.removeMyPhrase(phrase) } label: { Text("削除")
                                }
                                .tint(.red)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    }
                }
                .sheet(item: $selectedPhrase) { phrase in
                    PhraseDetailView(phrase: phrase)
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity)
                .scrollContentBackground(.hidden)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    MyPhrasesView()
        .environmentObject(PhraseStore())
}
