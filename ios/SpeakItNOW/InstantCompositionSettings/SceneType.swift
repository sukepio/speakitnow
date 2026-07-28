//
//  Scene.swift
//  SpeakItNOW
//
//  Created by 助名直人 on 2026/02/20.
//

import Foundation

enum SceneType: String, CaseIterable, Codable {
    case daily = "日常会話"
    case business = "ビジネス"
    case travel = "旅行"
    case shopping = "買い物"
    case dining = "レストラン・カフェ"
    case school = "学校・学習"
    case family = "家庭・家族"
    case social = "友人・交流"
    case healthcare = "健康・病院"
    case online = "電話・オンライン"
}
