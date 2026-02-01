//
//  SearchView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = "low-key"
    @State private var isLoading: Bool = false
    @State private var results: [Phrase] = [MockPhraseData.lowKey, MockPhraseData.neckAndNeck]
    @State private var errorMessage: String? = nil
    @State private var selectedPhrase: Phrase? = nil
    
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var body: some View {
        ZStack {
            Color(Color.black.opacity(0.9))
                .ignoresSafeArea()
            
            VStack() {
                Text("検索")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("", text: $query, prompt: Text("Enter a word, phrase, idiom"))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .submitLabel(.search)
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !trimmedQuery.isEmpty {
                        Button {
                            query = ""
                            results = []
                            isLoading = false
                            errorMessage = nil
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.gray)
                                .padding(2)
                                .contentShape(Rectangle())
                        }
                            .buttonStyle(.plain)
                    }
                    

                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.top, 32)
                
                content
                    .padding(.top, 24)
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 20)
        }
    }
    
    private func performSearch() {
        guard !trimmedQuery.isEmpty else { return }
        errorMessage = nil
        results = []
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if trimmedQuery == "low-key" {
                results.append(MockPhraseData.lowKey)
            } else if trimmedQuery == "neck and neck" {
                results.append(MockPhraseData.neckAndNeck)
            }
            isLoading = false
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView()
                .tint(.white)
        } else if results.isEmpty && trimmedQuery.isEmpty {
            Text("アウトプットしたい語句を検索しましょう")
                .foregroundStyle(.white)
        } else if results.isEmpty {
            Text("検索に該当する語句が見つかりませんでした")
                .foregroundStyle(.white)
        } else {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(results) { phrase in
                    PhraseRow(phrase: phrase)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPhrase = phrase
                        }
                }
            }
            .sheet(item: $selectedPhrase) { phrase in
                PhraseDetailView(phrase: phrase)
            }
        }
    }
}

#Preview {
    SearchView()
}
