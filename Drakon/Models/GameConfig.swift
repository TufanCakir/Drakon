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

    static let fallback = GameConfig(
        team: TeamConfig(maxActiveTeamSize: 4),
        starterSelection: StarterSelectionRules(
            requiredForNewAccount: true,
            selectionCount: 1
        )
    )
}

struct TeamConfig: Codable {
    let maxActiveTeamSize: Int
}

struct StarterSelectionRules: Codable {
    let requiredForNewAccount: Bool
    let selectionCount: Int
}
