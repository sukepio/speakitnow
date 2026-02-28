//
//  SearchView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    @State private var query: String = ""
    @State private var isLoading: Bool = false
    @State private var results: [Phrase] = []
    @State private var errorMessage: String? = nil
    @State private var selectedPhrase: Phrase? = nil
    @State private var path: [DetailRoute] = []
    
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
                        .foregroundStyle(.black)
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
                            selectedPhrase = nil
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
        let q = normalize(trimmedQuery)
        errorMessage = nil
        results = []
        isLoading = true
        let source = phraseStore.phrases
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            defer {
                isLoading = false
            }
            let exact = source.filter { normalize($0.text) == q }
            if !exact.isEmpty {
                results = exact
                return
            }
            let partial = source.filter { normalize($0.text).contains(q) }
            results = partial
            return
        }
    }
    
    private func normalize(_ s: String) -> String {
        var normalized = s.lowercased()
        normalized = normalized.trimmingCharacters(in: .whitespacesAndNewlines)
        normalized = normalized.replacingOccurrences(of: "-", with: " ")
        normalized = normalized.components(separatedBy: .whitespacesAndNewlines).filter{
            !$0.isEmpty
        }.joined(separator: " ")
        return normalized
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
                NavigationStack(path: $path) {
                    PhraseDetailView(
                        phrase: phrase,
                        source: .search,
                        onStartOutput: { phrase, source in
                            path.append(.output(pharase: phrase, source: .search))
                        }
                    )
                    .navigationDestination(for: DetailRoute.self) { route in
                        switch route {
                        case.output(let phrase, let source):
                            OutputView(
                                phrase: phrase,
                                source: source
                            )
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(PhraseStore())
}
