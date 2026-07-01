//
//  PhraseInsertDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/06/20.
//

import Foundation

struct PhraseInsertDTO: Encodable {
    let text: String
    let meaning_ja: String
    let normalized_text: String
    let phrase_details: PhraseDetailsDTO
}
