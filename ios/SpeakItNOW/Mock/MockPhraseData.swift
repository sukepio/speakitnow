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
        neckAndNeck,
        upInTheAir,
        flyOnTheWall,
        onTheFly,
        wasted,
        goDownWell,
        makeAKilling
    ]

    // MARK: - low-key
    static let lowKey = Phrase(
        id: 1,
        text: "low-key",
        meaningJa: "控えめに／さりげなく／実はちょっと",
        normalizedText: "low-key",
//        isRecommended: true,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「low-key」は、何かを大げさにせず、控えめ・さりげない形で行うときに使われます。
感情や評価を抑えて伝えたいときや、「実はちょっと〜」というニュアンスでもよく使われます。
""",
            contexts: [
                "感情や好みを控えめに伝えるとき",
                "公にしない・大げさにしない行動"
            ],
            conversations: [
                Conversation(
                    id: "con_lowkey_tpl_1",
                    text: "casual check-in",
                    meaningJa: "軽い近況トーク",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How’s your day going?",
                            ja: "今日どんな感じ？"
                        ),
                        second: BilingualText(
                            en: "I’m low-key tired today.",
                            ja: "今日は実はちょっと疲れてる。"
                        )
                    )
                ),
                Conversation(
                    id: "con_lowkey_tpl_2",
                    text: "preference",
                    meaningJa: "好みを控えめに言う",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "What kind of music do you listen to?",
                            ja: "どんな音楽聴くの？"
                        ),
                        second: BilingualText(
                            en: "I low-key like jazz.",
                            ja: "実はジャズちょっと好き。"
                        )
                    )
                ),
                Conversation(
                    id: "con_lowkey_tpl_3",
                    text: "suggestion",
                    meaningJa: "控えめに提案する",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "What should we do for the weekend?",
                            ja: "週末どうする？"
                        ),
                        second: BilingualText(
                            en: "Let’s keep it low-key.",
                            ja: "控えめにしよう。"
                        )
                    )
                )
            ],
            collocations: [
                Collocation(
                    id: "col_lowkey_1",
                    text: "low-key like ~",
                    meaningJa: "実は〜がちょっと好き",
                    conversationPair: ConversationPair(
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
                    conversationPair: ConversationPair(
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
        id: 2,
        text: "neck and neck",
        meaningJa: "接戦で／ほぼ同時に",
        normalizedText: "neck and neck",
//        isRecommended: false,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「neck and neck」は、勝負や競争でほとんど差がなく、互角の状態を表します。
スポーツやレース、選挙結果など、結果が拮抗している場面でよく使われます。
""",
            contexts: [
                "スポーツの試合やレース",
                "選挙結果・支持率"
            ],
            conversations: [
                Conversation(
                    id: "con_neck_tpl_1",
                    text: "competition update",
                    meaningJa: "勝負の状況を共有",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Any updates on the results?",
                            ja: "結果どうなった？"
                        ),
                        second: BilingualText(
                            en: "It’s neck and neck right now.",
                            ja: "今、接戦だよ。"
                        )
                    )
                ),
                Conversation(
                    id: "con_neck_tpl_2",
                    text: "two options",
                    meaningJa: "2つが拮抗している",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Which one is better, A or B?",
                            ja: "AとB、どっちがいい？"
                        ),
                        second: BilingualText(
                            en: "They’re neck and neck.",
                            ja: "ほぼ互角だね。"
                        )
                    )
                ),
                Conversation(
                    id: "con_neck_tpl_3",
                    text: "race reaction",
                    meaningJa: "接戦に驚く",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "That was intense, wasn’t it?",
                            ja: "すごかったね。"
                        ),
                        second: BilingualText(
                            en: "Yeah, it was neck and neck to the end.",
                            ja: "うん、最後まで接戦だった。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_neck_1",
                    text: "be neck and neck",
                    meaningJa: "〜と接戦状態にある",
                    conversationPair: ConversationPair(
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
                    conversationPair: ConversationPair(
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

    // MARK: - up in the air
    static let upInTheAir = Phrase(
        id: 3,
        text: "up in the air",
        meaningJa: "未定で／どうなるか分からない",
        normalizedText: "up in the air",
//        isRecommended: true,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「up in the air」は、物事がまだ決まっていない／先が読めない状態を表します。
予定・計画・判断などが確定していないときに、とても自然に使えます。
""",
            contexts: [
                "予定が未確定のとき（旅行・会議・イベントなど）",
                "意思決定や結果がまだ分からないとき"
            ],
            conversations: [
                Conversation(
                    id: "con_upair_tpl_1",
                    text: "plan status",
                    meaningJa: "予定が未定",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Are we meeting tomorrow?",
                            ja: "明日会う？"
                        ),
                        second: BilingualText(
                            en: "It’s still up in the air.",
                            ja: "まだ未定だよ。"
                        )
                    )
                ),
                Conversation(
                    id: "con_upair_tpl_2",
                    text: "decision pending",
                    meaningJa: "判断がまだ",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Did you decide what to do next?",
                            ja: "次どうするか決めた？"
                        ),
                        second: BilingualText(
                            en: "No, it’s up in the air.",
                            ja: "いや、まだ不透明。"
                        )
                    )
                ),
                Conversation(
                    id: "con_upair_tpl_3",
                    text: "uncertain schedule",
                    meaningJa: "スケジュールが確定していない",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Can you join the event?",
                            ja: "イベント来れる？"
                        ),
                        second: BilingualText(
                            en: "Maybe. My schedule is up in the air.",
                            ja: "たぶん。予定がまだ未定なんだ。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_upair_1",
                    text: "be up in the air",
                    meaningJa: "未定だ／不透明だ",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Are we still going on the trip?",
                            ja: "旅行、まだ行くの？"
                        ),
                        second: BilingualText(
                            en: "Not sure. It’s still up in the air.",
                            ja: "まだ分からない。未定なんだ。"
                        )
                    )
                ),
                Collocation(
                    id: "col_upair_2",
                    text: "leave ~ up in the air",
                    meaningJa: "〜を未定のままにしておく",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Did you decide the meeting time?",
                            ja: "会議の時間決めた？"
                        ),
                        second: BilingualText(
                            en: "No, we left it up in the air for now.",
                            ja: "いや、とりあえず未定のまま。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_upair_1",
                    en: "Our weekend plans are up in the air because of the weather.",
                    ja: "天気のせいで週末の予定が未定だ。"
                ),
                Example(
                    id: "ex_upair_2",
                    en: "The launch date is still up in the air.",
                    ja: "リリース日はまだ確定していない。"
                )
            ],
            origin: "物が空中に浮いていて落ち着く場所がない＝決まっていない、という比喩から来ています。",
            tips: "ビジネスでも日常でも使えます。『未定』をやわらかく言いたいときに便利。",
            similar: [
                SimilarPhrase(
                    id: "sim_upair_1",
                    phrase: "undecided",
                    meaningJa: "未決定の（ややフォーマル）"
                ),
                SimilarPhrase(
                    id: "sim_upair_2",
                    phrase: "not settled",
                    meaningJa: "まだ固まっていない"
                )
            ]
        )
    )

    // MARK: - fly on the wall
    static let flyOnTheWall = Phrase(
        id: 4,
        text: "fly on the wall",
        meaningJa: "こっそり見聞きする人／当事者に気づかれずその場にいる存在",
        normalizedText: "fly on the wall",
//        isRecommended: false,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「a fly on the wall」は、「その場の人に気づかれずに会話や出来事を見聞きできる存在」を表します。
ドラマや会議、カップルの会話など「中をのぞきたい」場面でよく出ます。
""",
            contexts: [
                "会議や内輪の会話をこっそり聞きたいとき",
                "ドラマやドキュメンタリーの表現（舞台裏を覗く感じ）"
            ],
            conversations: [
                Conversation(
                    id: "con_fly_tpl_1",
                    text: "curiosity",
                    meaningJa: "内緒の話を聞きたい",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "I wonder what they talked about.",
                            ja: "何話してたんだろうね。"
                        ),
                        second: BilingualText(
                            en: "I’d love to be a fly on the wall.",
                            ja: "こっそり聞けたら最高なのに。"
                        )
                    )
                ),
                Conversation(
                    id: "con_fly_tpl_2",
                    text: "behind the scenes",
                    meaningJa: "舞台裏を覗く感じ",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "This feels so real, like we’re watching quietly.",
                            ja: "なんかリアルだね、静かに見てる感じ。"
                        ),
                        second: BilingualText(
                            en: "Yeah, like a fly on the wall.",
                            ja: "うん、こっそり覗いてるみたい。"
                        )
                    )
                ),
                Conversation(
                    id: "con_fly_tpl_3",
                    text: "private conversation",
                    meaningJa: "プライベートな会話を見たい",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "They’re having a serious talk.",
                            ja: "真剣な話してるね。"
                        ),
                        second: BilingualText(
                            en: "I wish I were a fly on the wall.",
                            ja: "こっそりその場に居られたらな。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_fly_1",
                    text: "be a fly on the wall",
                    meaningJa: "こっそりその場を見聞きできる存在になる",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "I wonder what they said in that meeting.",
                            ja: "あの会議で何言ってたんだろうね。"
                        ),
                        second: BilingualText(
                            en: "Same. I’d love to be a fly on the wall.",
                            ja: "わかる。こっそり聞けたら最高。"
                        )
                    )
                ),
                Collocation(
                    id: "col_fly_2",
                    text: "like a fly on the wall",
                    meaningJa: "（比喩的に）こっそり見ているように",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "The camera follows them quietly.",
                            ja: "カメラが静かに彼らを追ってるね。"
                        ),
                        second: BilingualText(
                            en: "Yeah, it feels like a fly on the wall.",
                            ja: "うん、こっそり覗いてる感じがする。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_fly_1",
                    en: "I’d love to be a fly on the wall during their negotiation.",
                    ja: "彼らの交渉の場に、こっそり居られたらいいのに。"
                ),
                Example(
                    id: "ex_fly_2",
                    en: "The documentary style makes you feel like a fly on the wall.",
                    ja: "そのドキュメンタリー風の演出だと、こっそり覗いてる気分になる。"
                )
            ],
            origin: "壁に止まっているハエは人に気づかれにくい、というイメージから。",
            tips: "「a fly on the wall」が基本形。『fly』の前に a を付けるのが自然。",
            similar: [
                SimilarPhrase(
                    id: "sim_fly_1",
                    phrase: "eavesdrop",
                    meaningJa: "盗み聞きする（動詞）"
                ),
                SimilarPhrase(
                    id: "sim_fly_2",
                    phrase: "behind the scenes",
                    meaningJa: "舞台裏で"
                )
            ]
        )
    )

    // MARK: - on the fly
    static let onTheFly = Phrase(
        id: 5,
        text: "on the fly",
        meaningJa: "その場で即興で／素早く対応して",
        normalizedText: "on the fly",
//        isRecommended: true,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「on the fly」は、準備する時間があまりない中で、その場で判断して素早く対応するニュアンスです。
仕事の現場（仕様変更、トラブル対応）でも日常でもよく使われます。
""",
            contexts: [
                "予定変更に合わせて即興で動くとき",
                "仕事でその場判断・臨機応変に対応するとき"
            ],
            conversations: [
                Conversation(
                    id: "con_onthefly_tpl_1",
                    text: "no plan",
                    meaningJa: "計画なしで動く",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Do we need a plan?",
                            ja: "計画いる？"
                        ),
                        second: BilingualText(
                            en: "Let’s decide on the fly.",
                            ja: "その場で決めよう。"
                        )
                    )
                ),
                Conversation(
                    id: "con_onthefly_tpl_2",
                    text: "quick adjustment",
                    meaningJa: "即興で調整する",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Something changed last minute.",
                            ja: "直前で変更が入った。"
                        ),
                        second: BilingualText(
                            en: "Okay, we’ll adjust on the fly.",
                            ja: "了解、その場で調整しよう。"
                        )
                    )
                ),
                Conversation(
                    id: "con_onthefly_tpl_3",
                    text: "instant response",
                    meaningJa: "即対応する",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Can you handle it right now?",
                            ja: "今すぐ対応できる？"
                        ),
                        second: BilingualText(
                            en: "Yeah, I’ll do it on the fly.",
                            ja: "うん、その場でやるよ。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_fly2_1",
                    text: "decide on the fly",
                    meaningJa: "その場で決める",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Do we need a detailed plan?",
                            ja: "細かい計画いる？"
                        ),
                        second: BilingualText(
                            en: "Maybe not. Let’s decide on the fly.",
                            ja: "いらないかも。その場で決めよう。"
                        )
                    )
                ),
                Collocation(
                    id: "col_fly2_2",
                    text: "make changes on the fly",
                    meaningJa: "その場で調整する／即興で変更する",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "The client changed the requirements again.",
                            ja: "クライアントがまた要件変えたね。"
                        ),
                        second: BilingualText(
                            en: "Yeah, we’ll have to make changes on the fly.",
                            ja: "うん、その場で調整するしかないね。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_onthefly_1",
                    en: "I had to answer the questions on the fly.",
                    ja: "その場で質問に答えないといけなかった。"
                ),
                Example(
                    id: "ex_onthefly_2",
                    en: "We created a quick demo on the fly.",
                    ja: "その場でサクッとデモを作った。"
                )
            ],
            origin: "飛んでいる最中（＝止まって考える余裕がない）という比喩から。",
            tips: "『準備ゼロで即興』だけでなく、『臨機応変』の前向きなニュアンスでも使えます。",
            similar: [
                SimilarPhrase(
                    id: "sim_onthefly_1",
                    phrase: "improvise",
                    meaningJa: "即興でやる（動詞）"
                ),
                SimilarPhrase(
                    id: "sim_onthefly_2",
                    phrase: "spur of the moment",
                    meaningJa: "思いつきで／突発的に"
                )
            ]
        )
    )

    // MARK: - wasted
    static let wasted = Phrase(
        id: 6,
        text: "wasted",
        meaningJa: "（かなり）酔っぱらった／無駄になった",
        normalizedText: "wasted",
//        isRecommended: false,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「wasted」は主にカジュアルに「ベロベロに酔った」を表すスラング的表現です。
文脈によっては「（努力・時間などが）無駄になった」という意味にもなります。
""",
            contexts: [
                "飲み会で酔い具合をカジュアルに言うとき",
                "時間・努力が無駄になったと言うとき"
            ],
            conversations: [
                Conversation(
                    id: "con_wasted_tpl_1",
                    text: "hangover",
                    meaningJa: "酔いの話",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "You look rough. Are you okay?",
                            ja: "しんどそうだけど大丈夫？"
                        ),
                        second: BilingualText(
                            en: "Yeah… I got wasted last night.",
                            ja: "うん…昨日ベロベロになった。"
                        )
                    )
                ),
                Conversation(
                    id: "con_wasted_tpl_2",
                    text: "regret",
                    meaningJa: "やりすぎを反省",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Do you remember what happened?",
                            ja: "何があったか覚えてる？"
                        ),
                        second: BilingualText(
                            en: "Not really. I was wasted.",
                            ja: "あんまり…酔いつぶれてた。"
                        )
                    )
                ),
                Conversation(
                    id: "con_wasted_tpl_3",
                    text: "time wasted",
                    meaningJa: "無駄になった",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Why are you frustrated?",
                            ja: "なんでイライラしてるの？"
                        ),
                        second: BilingualText(
                            en: "It feels like my time was wasted.",
                            ja: "時間が無駄になった気がする。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_wasted_1",
                    text: "get wasted",
                    meaningJa: "ベロベロに酔う",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How was the party?",
                            ja: "パーティーどうだった？"
                        ),
                        second: BilingualText(
                            en: "Wild. People were getting wasted.",
                            ja: "やばかった。みんなベロベロだった。"
                        )
                    )
                ),
                Collocation(
                    id: "col_wasted_2",
                    text: "waste ~ / be wasted",
                    meaningJa: "（時間・お金などが）無駄になる",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "I spent hours on this, and it got rejected.",
                            ja: "これに何時間もかけたのに却下された。"
                        ),
                        second: BilingualText(
                            en: "That must feel like a wasted effort.",
                            ja: "それは努力が無駄になった感じだね。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_wasted_1",
                    en: "I got wasted last night, so I’m taking it easy today.",
                    ja: "昨夜ベロベロになったから、今日はゆっくりする。"
                ),
                Example(
                    id: "ex_wasted_2",
                    en: "All that preparation was wasted when the event got canceled.",
                    ja: "イベントが中止になって、準備が全部無駄になった。"
                )
            ],
            origin: "「消耗した／使い果たした」イメージから派生し、口語で「酔いつぶれた」の意味が強まりました。",
            tips: "酔いの意味はかなりカジュアル。ビジネスでは避けたほうが安全です。",
            similar: [
                SimilarPhrase(
                    id: "sim_wasted_1",
                    phrase: "drunk",
                    meaningJa: "酔っている（一般的）"
                ),
                SimilarPhrase(
                    id: "sim_wasted_2",
                    phrase: "tipsy",
                    meaningJa: "ほろ酔い（軽め）"
                )
            ]
        )
    )

    // MARK: - go down well
    static let goDownWell = Phrase(
        id: 7,
        text: "go down well",
        meaningJa: "好評だ／ウケがいい／受け入れられる",
        normalizedText: "go down well",
//        isRecommended: false,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「go down well」は、提案・ジョーク・スピーチ・新商品などが「人々に好意的に受け取られる」ことを表します。
「評判がいい」「ウケがいい」を自然に言える便利表現です。
""",
            contexts: [
                "提案やアイデアの反応を言うとき",
                "ジョークやスピーチのウケを言うとき"
            ],
            conversations: [
                Conversation(
                    id: "con_gdw_tpl_1",
                    text: "feedback",
                    meaningJa: "反応が良い",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How did your idea go?",
                            ja: "アイデアの反応どうだった？"
                        ),
                        second: BilingualText(
                            en: "It went down well.",
                            ja: "好評だったよ。"
                        )
                    )
                ),
                Conversation(
                    id: "con_gdw_tpl_2",
                    text: "with audience",
                    meaningJa: "〜にウケる",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Did the new rule get accepted?",
                            ja: "新ルール、受け入れられそう？"
                        ),
                        second: BilingualText(
                            en: "I don’t think it’ll go down well.",
                            ja: "たぶんウケないと思う。"
                        )
                    )
                ),
                Conversation(
                    id: "con_gdw_tpl_3",
                    text: "joke",
                    meaningJa: "冗談がウケる／ウケない",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Did your joke land?",
                            ja: "冗談ウケた？"
                        ),
                        second: BilingualText(
                            en: "It didn’t go down well.",
                            ja: "ウケなかった。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_gdw_1",
                    text: "go down well with ~",
                    meaningJa: "〜に好評だ／〜にウケる",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How did your presentation go?",
                            ja: "プレゼンどうだった？"
                        ),
                        second: BilingualText(
                            en: "It went down well with the team.",
                            ja: "チームに好評だったよ。"
                        )
                    )
                ),
                Collocation(
                    id: "col_gdw_2",
                    text: "won’t go down well",
                    meaningJa: "ウケない／受け入れられなさそう",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Should we cut the budget again?",
                            ja: "また予算削る？"
                        ),
                        second: BilingualText(
                            en: "That won’t go down well with everyone.",
                            ja: "それはみんなにウケないと思う。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_gdw_1",
                    en: "The new feature went down well with users.",
                    ja: "新機能はユーザーに好評だった。"
                ),
                Example(
                    id: "ex_gdw_2",
                    en: "His joke didn’t go down well in the meeting.",
                    ja: "彼の冗談は会議ではウケなかった。"
                )
            ],
            origin: "飲み物や食べ物が「スッと喉を通る」＝抵抗なく受け入れられる、という比喩から。",
            tips: "『with + 人』がセットで出やすいです（with the team / with users など）。",
            similar: [
                SimilarPhrase(
                    id: "sim_gdw_1",
                    phrase: "be well received",
                    meaningJa: "好評を得る（フォーマル）"
                ),
                SimilarPhrase(
                    id: "sim_gdw_2",
                    phrase: "be a hit",
                    meaningJa: "大ウケする／大ヒットする（口語）"
                )
            ]
        )
    )

    // MARK: - make a killing
    static let makeAKilling = Phrase(
        id: 8,
        text: "make a killing",
        meaningJa: "（大金を）ガッポリ稼ぐ／大儲けする",
        normalizedText: "make a killing",
//        isRecommended: true,
        phraseDetails: PhraseDetails(
            detailedMeaning: """
「make a killing」は「短期間で大きく儲ける」「想像以上に稼ぐ」という強い表現です。
投資・セール・ビジネスなど、結果が“大成功”だったときにカジュアルに使えます。
""",
            contexts: [
                "ビジネスや副業で大きく稼いだ話をするとき",
                "イベント・セールなどで大成功したとき"
            ],
            conversations: [
                Conversation(
                    id: "con_makill_tpl_1",
                    text: "business result",
                    meaningJa: "稼ぎがすごい",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How’s business lately?",
                            ja: "最近どう？"
                        ),
                        second: BilingualText(
                            en: "We’re making a killing.",
                            ja: "めっちゃ儲かってる。"
                        )
                    )
                ),
                Conversation(
                    id: "con_makill_tpl_2",
                    text: "one-time big profit",
                    meaningJa: "一発で大儲け",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Was that project worth it?",
                            ja: "その案件、やる価値あった？"
                        ),
                        second: BilingualText(
                            en: "Yeah, I made a killing on it.",
                            ja: "うん、あれで大儲けした。"
                        )
                    )
                ),
                Conversation(
                    id: "con_makill_tpl_3",
                    text: "surprised reaction",
                    meaningJa: "儲けに驚く",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How did you afford that?",
                            ja: "どうやってそれ買えたの？"
                        ),
                        second: BilingualText(
                            en: "I made a killing last month.",
                            ja: "先月大儲けしたんだ。"
                        )
                    )
                )
            ],

            collocations: [
                Collocation(
                    id: "col_makill_1",
                    text: "make a killing on ~",
                    meaningJa: "〜で大儲けする",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "How was your online store last month?",
                            ja: "先月のネットショップどうだった？"
                        ),
                        second: BilingualText(
                            en: "Amazing. We made a killing on that campaign.",
                            ja: "最高。あのキャンペーンで大儲けした。"
                        )
                    )
                ),
                Collocation(
                    id: "col_makill_2",
                    text: "make a killing selling ~",
                    meaningJa: "〜を売って大儲けする",
                    conversationPair: ConversationPair(
                        first: BilingualText(
                            en: "Why are those tickets so expensive?",
                            ja: "なんでチケットそんな高いの？"
                        ),
                        second: BilingualText(
                            en: "Resellers are making a killing selling them.",
                            ja: "転売ヤーがそれで大儲けしてるんだよ。"
                        )
                    )
                )
            ],
            examples: [
                Example(
                    id: "ex_makill_1",
                    en: "They made a killing when the product went viral.",
                    ja: "商品がバズって、彼らは大儲けした。"
                ),
                Example(
                    id: "ex_makill_2",
                    en: "You can make a killing if you time it right.",
                    ja: "タイミングが合えば、ガッポリ稼げるよ。"
                )
            ],
            origin: "“killing” は比喩で「圧勝・大成功」を表す用法があり、そこから『大儲け』の意味になりました。",
            tips: "やや強い・俗っぽい言い方なので、フォーマルな場では『make a lot of money』や『do very well』が無難。",
            similar: [
                SimilarPhrase(
                    id: "sim_makill_1",
                    phrase: "make a fortune",
                    meaningJa: "大金持ちになる／大金を稼ぐ"
                ),
                SimilarPhrase(
                    id: "sim_makill_2",
                    phrase: "cash in",
                    meaningJa: "（好機に乗じて）儲ける"
                )
            ]
        )
    )
}
