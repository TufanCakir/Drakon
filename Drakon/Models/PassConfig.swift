//
//  PassConfig.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct PassConfig: Codable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let currencyTitle: String
    let pointsPerTier: Int
    let tiers: [PassTier]
}

struct PassTier: Codable, Identifiable {
    let tier: Int
    let free: PassReward?
    let premium: PassReward?

    var id: Int { tier }
}

struct PassReward: Codable, Hashable {
    let title: String
    let type: GiftType
    let amount: Int?
    let characterId: String?
    let eggId: String?
    let skinId: String?
}

enum PassLoader {
    static func load() -> PassConfig? {
        do {
            return try JSONLoader.load("pass_rewards")
        } catch {
            print("pass_rewards.json konnte nicht geladen werden:", error)
            return nil
        }
    }
}
