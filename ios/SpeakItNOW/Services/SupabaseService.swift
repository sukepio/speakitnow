//
//  SupabaseService.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/27.
//

import Foundation
import Supabase

final class SupabaseService {
    private let supabase = SupabaseProvider.client
    
    func fetchPhrases() async throws -> [PhraseDTO] {
        let test : [PhraseDTO] = try await supabase.from("phrases").select("id, text, meaning_ja, phrase_details").limit(1).execute().value
        return test
    }
}
