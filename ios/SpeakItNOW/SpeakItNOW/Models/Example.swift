//
//  Example.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

struct Example: Identifiable, Codable, Hashable {
    let id: String
    let en: String
    let ja: String

    // 将来の拡張（必要になったら使う）
    var audioURL: URL?
    var source: String?
    var tags: [String]?
}
