//
//  ConversationDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/02.
//

import Foundation

struct ConversationDTO: Decodable {
    let id: String
    let text: String
    let meaning_ja: String
    let conversation_pair: ConversationPairDTO
}
