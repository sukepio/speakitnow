//
//  PhraseDetailsDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/02.
//

import Foundation

struct PhraseDetailsDTO: Codable {
    let detailed_meaning: String
    let contexts: [String]
    let conversations: [ConversationDTO]
    let collocations: [CollocationDTO]
    let examples: [ExampleDTO]
    let origin: String
    let tips: String
    let similar: [SimilarPhraseDTO]
}
