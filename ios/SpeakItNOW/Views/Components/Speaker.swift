//
//  Speaker.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/01/31.
//

import Foundation

enum Speaker {
    case a, b
    
    var label: String {
        switch self {
        case .a:
            return "A"
        case .b:
            return "B"
        }
    }

}

