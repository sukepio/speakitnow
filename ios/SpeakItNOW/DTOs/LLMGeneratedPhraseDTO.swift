//
//  LLMGeneratedPhraseDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/06/12.
//

import Foundation

struct LLMGeneratedPhraseDTO: Decodable {
    let text: String
    let meaning_ja: String
    let phrase_details: PhraseDetailsDTO
}
