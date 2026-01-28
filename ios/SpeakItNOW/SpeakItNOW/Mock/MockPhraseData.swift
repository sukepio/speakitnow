//
//  MockPhraseData.swift
//  
//
//  Created by 助名直人 on 2026/01/17.
//

import Foundation

struct MockPhraseData {

    static let phrases: [Phrase] = [
        lowKey,
        neckAndNeck
    ]

    // MARK: - low-key
    static let lowKey = Phrase(
        id: "p_low_key",
        text: "low-key",
        meaningJa: "控えめに／さりげなく／実はちょっと",
        isRecommended: true,
        details: PhraseDetails(
            detailedMeaning: """
「low-key」は、何かを大げさにせず、控えめ・さりげない形で行うときに使われます。
感情や評価を抑えて伝えたいときや、「実はちょっと〜」というニュアンスでもよく使われます。
""",
            contexts: [
                "感情や好みを控えめに伝えるとき",
                "公にしない・大げさにしない行動"
            ],
            collocations: [
                Collocation(
                    id: "col_lowkey_1",
                    text: "low-key like ~",
                    meaningJa: "実は〜がちょっと好き",
                    conversation: ConversationPair(
                        first: BilingualText(
                            en: "I’m low-key into jazz these days.",
                            ja: "最近、実はジャズにちょっとハマってるんだ。"
                        ),
                        second: BilingualText(
                            en: "Really? I didn’t know that.",
                            ja: "そうなんだ、知らなかった。"
                        )
                    )
                ),
                Collocation(
                    id: "col_lowkey_2",
                    text: "keep it low-key",
                    meaningJa: "控えめにする／大ごとにしない",
                    conversation: ConversationPair(
                        first: BilingualText(
                            en: "Let’s keep the party low-key.",
                            ja: "パーティーは控えめにやろう。"
                        ),
                        second: BilingualText(
                            en: "Yeah, just close friends.",
                            ja: "うん、親しい人だけでね。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_lowkey_1",
                    en: "I was low-key nervous before the interview.",
                    ja: "面接の前、実はちょっと緊張してた。"
                ),
                Example(
                    id: "ex_lowkey_2",
                    en: "They had a low-key wedding with family only.",
                    ja: "彼らは家族だけの控えめな結婚式を挙げた。"
                )
            ],
            origin: "もともとは音楽用語で「音量や強弱を抑えた」という意味から派生しました。",
            tips: "カジュアルな会話で非常によく使われます。フォーマルな場では使いすぎに注意。",
            similar: [
                SimilarPhrase(
                    id: "sim_lowkey_1",
                    phrase: "subtle",
                    meaningJa: "控えめな／微妙な"
                ),
                SimilarPhrase(
                    id: "sim_lowkey_2",
                    phrase: "kind of",
                    meaningJa: "ちょっと／なんとなく"
                )
            ]
        )
    )

    // MARK: - neck and neck
    static let neckAndNeck = Phrase(
        id: "p_neck_and_neck",
        text: "neck and neck",
        meaningJa: "接戦で／ほぼ同時に",
        isRecommended: false,
        details: PhraseDetails(
            detailedMeaning: """
「neck and neck」は、勝負や競争でほとんど差がなく、互角の状態を表します。
スポーツやレース、選挙結果など、結果が拮抗している場面でよく使われます。
""",
            contexts: [
                "スポーツの試合やレース",
                "選挙結果・支持率"
            ],
            collocations: [
                Collocation(
                    id: "col_neck_1",
                    text: "be neck and neck",
                    meaningJa: "〜と接戦状態にある",
                    conversation: ConversationPair(
                        first: BilingualText(
                            en: "Who’s winning the race?",
                            ja: "誰がレースで勝ってるの？"
                        ),
                        second: BilingualText(
                            en: "It’s neck and neck between Tom and Jake.",
                            ja: "トムとジェイクがほぼ同時だよ。"
                        )
                    )
                ),
                Collocation(
                    id: "col_neck_2",
                    text: "neck-and-neck competition",
                    meaningJa: "接戦の競争",
                    conversation: ConversationPair(
                        first: BilingualText(
                            en: "That was an exciting match.",
                            ja: "すごくエキサイティングな試合だったね。"
                        ),
                        second: BilingualText(
                            en: "Yeah, it was a real neck-and-neck competition.",
                            ja: "うん、本当に接戦だった。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_neck_1",
                    en: "The two teams were neck and neck until the final minute.",
                    ja: "その2チームは最後の1分まで接戦だった。"
                ),
                Example(
                    id: "ex_neck_2",
                    en: "The election results are neck and neck.",
                    ja: "選挙結果は接戦だ。"
                )
            ],
            origin: "競馬で馬同士の首（neck）が並ぶ様子から生まれた表現です。",
            tips: "『差がほぼゼロ』のときに使います。明確な勝敗がある場合には使いません。",
            similar: [
                SimilarPhrase(
                    id: "sim_neck_1",
                    phrase: "close race",
                    meaningJa: "接戦（ややフォーマル／客観的）"
                ),
                SimilarPhrase(
                    id: "sim_neck_2",
                    phrase: "tight competition",
                    meaningJa: "競争が激しい（ビジネス寄り）"
                )
            ]
        )
    )
}
