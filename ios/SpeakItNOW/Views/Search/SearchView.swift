//
//  SearchView.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var phraseStore: PhraseStore
    @StateObject var searchViewModel = SearchViewModel()

    @State private var selectedPhrase: Phrase? = nil
    @State private var path: [DetailRoute] = []
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("検索")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    searchBar

                    content
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(item: $selectedPhrase) { phrase in
            NavigationStack(path: $path) {
                PhraseDetailView(
                    phrase: phrase,
                    source: .search,
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
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.55))

            TextField(
                "",
                text: $searchViewModel.searchText,
                prompt: Text("英単語・フレーズ・イディオムを検索")
                    .foregroundStyle(.white.opacity(0.45))
            )
            .foregroundStyle(.white)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .submitLabel(.search)
            .onSubmit {
                performSearch()
            }

            if searchViewModel.canSearch {
                Button {
                    searchViewModel.resetSearch()
                    selectedPhrase = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.55))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("検索内容を消去")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
    
    private func performSearch() {
        Task {
            await searchViewModel.performSearch()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if searchViewModel.isLoading {
            Spacer()
            ProgressView("検索中...")
                .tint(.white)
                .foregroundStyle(.white)
            Spacer()
        } else if let message = searchViewModel.errorMessage {
            statusView(
                icon: "exclamationmark.triangle",
                title: "検索できませんでした",
                message: message
            )
        } else if searchViewModel.isInitialState {
            statusView(
                icon: "magnifyingglass",
                title: "英語表現を検索しましょう",
                message: "アウトプットしたい単語やフレーズを入力してください。"
            )
        } else if searchViewModel.hasNoResults {
            statusView(
                icon: "magnifyingglass",
                title: "検索結果がありません",
                message: "別の単語やフレーズでもう一度お試しください。"
            )
        } else {
            List {
                ForEach(searchViewModel.results) { searchResult in
                    PhraseRow(item: searchResult)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPhrase = searchResult
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    private func statusView(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.45))
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    SearchView()
        .environmentObject(PhraseStore())
}
