//
//  DailyReward.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct DailyReward: Codable, Identifiable {
    let day: Int

    let coins: Int?
    let gems: Int?
    let ruby: Int?
    let draken: Int?
    let shards: Int?
    let eventCurrency: Int?
    let exp: Int?

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
