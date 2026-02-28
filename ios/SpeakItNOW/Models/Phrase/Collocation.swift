//
//  Collocation.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

struct Collocation: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let meaningJa: String
    let conversation: ConversationPair
}
