//
//  SearchViewModel.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/09.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var results: [Phrase] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository = PhraseRepository()
    
    private var hasSearched: Bool = false
    
    var trimmedQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var canSearch: Bool {
        !trimmedQuery.isEmpty
    }
    
    var isInitialState: Bool {
        !hasSearched && results.isEmpty && trimmedQuery.isEmpty
    }
    
    var hasNoResults: Bool {
        hasSearched && !isLoading && errorMessage == nil && results.isEmpty
    }
    
    // 検索
    func performSearch() async {
        guard !trimmedQuery.isEmpty else { return }
        
        hasSearched = true
        errorMessage = nil
        isLoading = true
        
        do {
            defer { isLoading = false }
            results = try await repository.searchPhrases(query: trimmedQuery)
        } catch {
            print("search error:", error)
            errorMessage = error.localizedDescription
            results = []
        }
    }
    
    func resetSearch() {
        searchText = ""
        results = []
        // TODO: what to do when pressing the clear button in the middle of searching
        isLoading = false
        errorMessage = nil
        hasSearched = false
    }
    
    
}
