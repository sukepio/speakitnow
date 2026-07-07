//
//  UserPhraseRepository.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/06/30.
//

import Foundation
import Supabase

final class UserPhraseRepository {
    // MARK: - Development-only auth (DEBUG builds)
    #if DEBUG
    private struct DevAuth {
        // Set your development credentials here. DO NOT commit real credentials.
        // You can also consider reading these from a secure local config for development.
        static let email: String = "naoto927sukena@gmail.com"
        static let password: String = "naoto927"
    }

    @discardableResult
    private func ensureSignedInForDevelopment() async throws -> Bool {
        // Only attempt in DEBUG builds and when there is no current session
        if supabase.auth.currentSession == nil {
            guard !DevAuth.email.isEmpty, !DevAuth.password.isEmpty else {
                // If not configured, skip silently. Caller will still fail at currentUserId() if needed.
                return false
            }
            do {
                // Sign in with email/password for development
                try await supabase.auth.signIn(
                    email: DevAuth.email,
                    password: DevAuth.password
                )
                print("[DevAuth] Signed in test user successfully.")
                return true
            } catch {
                print("[DevAuth] Sign-in failed: \(error.localizedDescription)")
                throw error
            }
        }
        return false
    }
    #endif
    
    let supabase = SupabaseClient(
      supabaseURL: URL(string: "https://myajfjhsmscznlknhrxh.supabase.co")!,
      supabaseKey: "sb_publishable_bFMICOIn2u382RMOqn-QFg_6UsF4mwG"
    )
    
    
    // 取得
    func fetchMyPhraseIds() async throws -> Set<Int> {
        #if DEBUG
        _ = try? await ensureSignedInForDevelopment()
        #endif
        let userId = try currentUserId()
        let myPhraseIds: Set<Int> = try await fetchUserPhraseIds(userId: userId)
        return myPhraseIds
    }
    
    // 追加
    func addMyPhrase(phraseId: Int) async throws {
        #if DEBUG
        _ = try? await ensureSignedInForDevelopment()
        #endif
        let userId = try currentUserId()
        let userPhrase = UserPhraseInsertDTO(user_id: userId, phrase_id: phraseId)
        try await insertUserPhrase(userPhrase: userPhrase)
    }
    
    // 削除
    func removeMyPhrase(phraseId: Int) async throws {
        #if DEBUG
        _ = try? await ensureSignedInForDevelopment()
        #endif
        try await deleteUserPhrase(phraseId: phraseId)
    }
    
    private func currentUserId() throws -> UUID {
        guard let session = supabase.auth.currentSession else {
            throw NSError(domain: "UserPhraseRepository", code: 401, userInfo: [
                NSLocalizedDescriptionKey: "ログイン中のユーザーが見つかりません。"
            ])
        }
        
        return session.user.id
    }
    
    private func fetchUserPhraseIds(userId: UUID) async throws -> Set<Int> {
        let dtos: [UserPhraseDTO] = try await supabase
            .from("user_phrases")
            .select("phrase_id")
            .eq("user_id", value: userId)
            .execute()
            .value
        
        return Set(dtos.map(\.phrase_id))
    }
    
    private func insertUserPhrase(userPhrase: UserPhraseInsertDTO) async throws {
        try await supabase
            .from("user_phrases")
            .insert(userPhrase)
            .execute()
    }
    
    private func deleteUserPhrase(phraseId: Int) async throws {
        let userId = try currentUserId()
        try await supabase
            .from("user_phrases")
            .delete()
            .eq("user_id", value: userId)
            .eq("phrase_id", value: phraseId)
            .execute()
    }
}

