//
//  GameConfig.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct GameConfig: Codable {
    let team: TeamConfig
    let starterSelection: StarterSelectionRules
    let battleDifficulties: [BattleDifficulty]
    let storyChapters: [StoryChapter]

    static let fallback = GameConfig(
        team: TeamConfig(maxActiveTeamSize: 4),
        starterSelection: StarterSelectionRules(
            requiredForNewAccount: true,
            selectionCount: 1
        ),
        battleDifficulties: [
            BattleDifficulty(
                id: "normal",
                title: "Normal",
                enemyHpMultiplier: 1.0,
                rewardMultiplier: 1.0
            )
        ],
        storyChapters: []
    )
}

struct TeamConfig: Codable {
    let maxActiveTeamSize: Int
}

struct StarterSelectionRules: Codable {
    let requiredForNewAccount: Bool
    let selectionCount: Int
}

struct BattleDifficulty: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let enemyHpMultiplier: Double
    let rewardMultiplier: Double
}

struct StoryChapter: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let enemyImage: String
    let enemyElement: String
    let storyText: String
    let targetStages: Int
    let rewards: EventRewards?
}
