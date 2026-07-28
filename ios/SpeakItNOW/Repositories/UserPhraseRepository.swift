//
//  UserPhraseRepository.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/06/30.
//

import Foundation
import Supabase

final class UserPhraseRepository {
    private let supabase = SupabaseProvider.client
    
    // 取得
    func fetchMyPhraseIds() async throws -> Set<Int> {
        let userId = try await AuthenticationService.shared.ensureAuthenticated()
        let myPhraseIds: Set<Int> = try await fetchUserPhraseIds(userId: userId)
        return myPhraseIds
    }
    
    // 追加
    func addMyPhrase(phraseId: Int) async throws {
        let userId = try await AuthenticationService.shared.ensureAuthenticated()
        let userPhrase = UserPhraseInsertDTO(user_id: userId, phrase_id: phraseId)
        try await insertUserPhrase(userPhrase: userPhrase)
    }
    
    // 削除
    func removeMyPhrase(phraseId: Int) async throws {
        let userId = try await AuthenticationService.shared.ensureAuthenticated()
        try await deleteUserPhrase(userId: userId, phraseId: phraseId)
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
    
    private func deleteUserPhrase(userId: UUID, phraseId: Int) async throws {
        try await supabase
            .from("user_phrases")
            .delete()
            .eq("user_id", value: userId)
            .eq("phrase_id", value: phraseId)
            .execute()
    }
}
