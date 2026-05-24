//
//  RewardApplier.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

enum RewardApplier {
    static func apply(
        type: GiftType,
        amount: Int?,
        characterId: String?,
        eggId: String?,
        skinId: String?,
        teamManager: TeamManager?
    ) {
        let amount = amount ?? 0

        switch type {
        case .coins:
            CoinManager.shared.add(amount)
        case .gems:
            GemManager.shared.add(amount)
        case .exp:
            PlayerProgressManager.shared.addEXP(amount)
        case .ruby:
            RubyManager.shared.add(amount)
        case .shards:
            ShardManager.shared.add(amount)
        case .eventCurrency:
            EventCurrencyManager.shared.add(amount)
        case .draken:
            DrakenManager.shared.add(amount)
        case .egg:
            if let eggId {
                EggInventoryManager.shared.add(max(1, amount), eggId: eggId)
            }
        case .skin:
            if let skinId {
                SkinInventoryManager.shared.unlock(skinId)
            }
        case .drakon:
            addDrakon(characterId: characterId, teamManager: teamManager)
        }
    }

    private static func addDrakon(
        characterId: String?,
        teamManager: TeamManager?
    ) {
        guard let characterId, let teamManager else { return }

        do {
            let characters: [Character] = try JSONLoader.load("characters")
            guard
                let character = characters.first(where: { $0.id == characterId }
                )
            else {
                print("Reward Drakon not found:", characterId)
                return
            }
            teamManager.addOwnedCharacter(OwnedCharacter(base: character))
        } catch {
            print("Reward Drakon load failed:", error)
        }
    }
}
