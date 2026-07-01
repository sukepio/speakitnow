//
//  ConversationPairDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/02.
//

import Foundation

struct ConversationPairDTO: Codable {
    let first: BilingualTextDTO
    let second: BilingualTextDTO
}

struct BilingualTextDTO: Codable {
    let en: String
    let ja: String
}
