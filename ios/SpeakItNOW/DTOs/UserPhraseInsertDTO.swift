//
//  UserPhraseInsertDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/06/30.
//

import Foundation

struct UserPhraseInsertDTO: Encodable {
    let user_id: UUID
    let phrase_id: Int
}
