//
//  UpgradeConfig.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct UpgradeConfigRoot: Codable {
    let medalDefinitions: [DrakonMedalDefinition]
    let starCosts: [StarUpgradeCost]
}

struct DrakonMedalDefinition: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String
    let characterId: String
}

struct StarUpgradeCost: Codable, Identifiable, Hashable {
    let fromStar: Int
    let toStar: Int
    let medals: Int
    let coins: Int?

    var id: Int { fromStar }
}

enum UpgradeConfigLoader {
    static func load() -> UpgradeConfigRoot {
        do {
            return try JSONLoader.load("upgrade_config")
        } catch {
            print("upgrade_config.json konnte nicht geladen werden:", error)
            return UpgradeConfigRoot(
                medalDefinitions: [],
                starCosts: [
                    StarUpgradeCost(
                        fromStar: 1,
                        toStar: 2,
                        medals: 20,
                        coins: 100
                    ),
                    StarUpgradeCost(
                        fromStar: 2,
                        toStar: 3,
                        medals: 45,
                        coins: 250
                    ),
                    StarUpgradeCost(
                        fromStar: 3,
                        toStar: 4,
                        medals: 90,
                        coins: 600
                    ),
                    StarUpgradeCost(
                        fromStar: 4,
                        toStar: 5,
                        medals: 160,
                        coins: 1200
                    ),
                    StarUpgradeCost(
                        fromStar: 5,
                        toStar: 6,
                        medals: 260,
                        coins: 2200
                    ),
                    StarUpgradeCost(
                        fromStar: 6,
                        toStar: 7,
                        medals: 420,
                        coins: 4000
                    ),
                ]
            )
        }
    }
}
