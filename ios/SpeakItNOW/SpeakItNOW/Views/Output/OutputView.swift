//
//  OutputView.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/08.
//

import SwiftUI

struct OutputView: View {
    let phrase: Phrase
    let source: PhraseDetailSource
    
    var body: some View {
        Text("You're on Output View right now!")
    }
}

#Preview {
    OutputView(
        phrase: MockPhraseData.lowKey, source: .myPhrase
    )
}
