//
//  ExampleDTO.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/04/02.
//

import Foundation

struct ExampleDTO: Decodable {
    let id: String
    let en: String
    let ja: String

    // 将来の拡張（必要になったら使う）
    var audio_url: URL?
    var source: String?
    var tags: [String]?
}
