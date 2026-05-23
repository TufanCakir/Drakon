//
//  EggConfig.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct EggConfigRoot: Codable {
    let eggs: [DrakonEgg]
}

struct DrakonEgg: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let eggImage: String
    let babyImage: String
    let characterId: String
    let hatchCostDraken: Int
    let rarity: CharacterRarity
    let element: String?
    let description: String?
}

enum EggConfigLoader {
    static func load() -> EggConfigRoot {
        do {
            return try JSONLoader.load("eggs")
        } catch {
            print("eggs.json konnte nicht geladen werden:", error)
            return EggConfigRoot(eggs: [])
        }
    }
}
