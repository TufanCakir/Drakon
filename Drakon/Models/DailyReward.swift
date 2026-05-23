//
//  DailyReward.swift
//  Drakon
//
//  Created by Tufan Cakir on 06.03.26.
//

import Foundation

struct DailyReward: Codable, Identifiable {
    let day: Int

    let coins: Int?
    let gems: Int?
    let exp: Int?

    let corruptedCoins: Int?
    let corruptedGems: Int?

    var id: Int { day }
}

enum DailyRewardLoader {

    static func load() -> [DailyReward] {
        do {
            let rewards: [DailyReward] = try JSONLoader.load("daily_rewards")
            return rewards.sorted { $0.day < $1.day }
        } catch {
            print("daily_rewards.json konnte nicht geladen werden:", error)
            return []
        }
    }
}
