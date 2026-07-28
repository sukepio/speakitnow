//
//  Supabase.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/26.
//


import Foundation
import Supabase

enum SupabaseConfiguration {
    static let url: URL = {
        let value = requiredValue(forKey: "SUPABASE_URL")
        guard let url = URL(string: value) else {
            fatalError("SUPABASE_URLが不正です。")
        }
        return url
    }()

    static let publishableKey = requiredValue(forKey: "SUPABASE_PUBLISHABLE_KEY")

    private static func requiredValue(forKey key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            fatalError("\(key)が設定されていません。")
        }
        return value
    }
}

enum SupabaseProvider {
    static let client = SupabaseClient(
        supabaseURL: SupabaseConfiguration.url,
        supabaseKey: SupabaseConfiguration.publishableKey
    )
}
