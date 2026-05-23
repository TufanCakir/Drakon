//
//  EventVictoryResult.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct EventVictoryResult: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let coins: Int
    let rubies: Int
    let eventTokens: Int
    let draken: Int
    let eggRewards: [EggReward]
    let medalId: String?
    let medalTitle: String?
    let medalIcon: String?
    let medals: Int
}
