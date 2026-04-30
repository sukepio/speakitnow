//
//  PhraseDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/03/27.
//

import Foundation

struct PhraseDTO: Decodable {
    let id: Int64
    let text: String
    let meaning_ja: String
    let normalized_text: String
    let phrase_details: PhraseDetailsDTO
//    let conversation_templates: ConversationTemplateDTO
}
