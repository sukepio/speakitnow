//
//  HistoryViewModel.swift
//  SpeakItNOW
//

import Foundation

enum HistoryDifficultyFilter: String, CaseIterable, Identifiable {
    case all = "すべて"
    case beginner = "初級"
    case intermediate = "中級"
    case advanced = "上級"

    var id: String { rawValue }
}

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var sessions: [InstantCompositionHistorySession] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedFilter: HistoryDifficultyFilter = .all

    private let repository: InstantCompositionHistoryRepository

    init(repository: InstantCompositionHistoryRepository = InstantCompositionHistoryRepository()) {
        self.repository = repository
    }

    var filteredSessions: [InstantCompositionHistorySession] {
        guard selectedFilter != .all else { return sessions }
        return sessions.filter { $0.difficulty == selectedFilter.rawValue }
    }

    func loadSessions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            sessions = try await repository.fetchSessions()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteSession(_ session: InstantCompositionHistorySession) async {
        let previousSessions = sessions
        sessions.removeAll { $0.id == session.id }

        do {
            try await repository.deleteSession(session)
            errorMessage = nil
        } catch {
            sessions = previousSessions
            errorMessage = error.localizedDescription
        }
    }
}
