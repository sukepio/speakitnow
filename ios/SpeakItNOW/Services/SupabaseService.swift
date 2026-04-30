//
//  SupabaseService.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/27.
//

import Foundation
import Supabase

final class SupabaseService {
    
    let supabase = SupabaseClient(
      supabaseURL: URL(string: "https://myajfjhsmscznlknhrxh.supabase.co")!,
      supabaseKey: "sb_publishable_bFMICOIn2u382RMOqn-QFg_6UsF4mwG"
    )
    
    func fetchPhrases() async throws -> [PhraseDTO] {
        let test : [PhraseDTO] = try await supabase.from("phrases").select("id, text, meaning_ja, phrase_details").limit(1).execute().value
        return test
    }
}
