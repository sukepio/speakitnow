//
//  Conversation.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

struct ConversationPair: Codable, Hashable {
    let first: BilingualText
    let second: BilingualText
}

struct BilingualText: Codable, Hashable {
    let en: String
    let ja: String
}
