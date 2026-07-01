//
//  UserPhraseRepository.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/06/30.
//

import Foundation
import Supabase

final class UserPhraseRepository {
    let supabase = SupabaseClient(
      supabaseURL: URL(string: "https://myajfjhsmscznlknhrxh.supabase.co")!,
      supabaseKey: "sb_publishable_bFMICOIn2u382RMOqn-QFg_6UsF4mwG"
    )
    
    // 取得
    func fetchMyPhraseIds() async throws -> Set<Int> {
        let userId = try currentUserId()
        let myPhraseIds: Set<Int> = try await fetchUserPhraseIds(userId: userId)
        return myPhraseIds
    }
    
    // 追加
    func addMyPhrase(phraseId: Int) async throws {
        let userId = try currentUserId()
        let userPhrase = UserPhraseInsertDTO(user_id: userId, phrase_id: phraseId)
        try await insertUserPhrase(userPhrase: userPhrase)
    }
    
    // 削除
    func removeMyPhrase(phraseId: Int) async throws {
        try await removeUserPhrase(phraseId: phraseId)
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
    
    private func removeUserPhrase(phraseId: Int) async throws {
        let userId = try currentUserId()
        try await supabase
            .from("user_phrases")
            .delete()
            .eq("user_id", value: userId)
            .eq("phrase_id", value: phraseId)
            .execute()
    }
}

