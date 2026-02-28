//
//  DetailRoute.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/08.
//

import Foundation

enum DetailRoute: Hashable {
    case output(pharase: Phrase, source: PhraseDetailSource)
}
