//
//  Conversation.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/17.
//

import Foundation

struct Conversation: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let meaningJa: String
    let conversationPair: ConversationPair
}
