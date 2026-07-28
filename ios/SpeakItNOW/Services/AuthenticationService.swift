//
//  AuthenticationService.swift
//  SpeakItNOW
//

import Foundation
import Supabase

actor AuthenticationService {
    static let shared = AuthenticationService()

    private let supabase: SupabaseClient
    private var signInTask: Task<Session, Error>?

    init(supabase: SupabaseClient = SupabaseProvider.client) {
        self.supabase = supabase
    }

    func ensureAuthenticated() async throws -> UUID {
        try await validSession().user.id
    }

    func accessToken() async throws -> String {
        try await validSession().accessToken
    }

    private func validSession() async throws -> Session {
        if supabase.auth.currentSession != nil {
            return try await supabase.auth.session
        }

        if let signInTask {
            return try await signInTask.value
        }

        let task = Task { [supabase] in
            try await supabase.auth.signInAnonymously()
        }
        signInTask = task

        do {
            let session = try await task.value
            signInTask = nil
            return session
        } catch {
            signInTask = nil
            throw error
        }
    }
}
