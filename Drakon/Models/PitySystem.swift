//
//  PitySystem.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

struct PitySystem: Codable {
    let enabled: Bool
    let requiredPulls: Int
    let guaranteedPool: [PityEntry]
}

struct PityEntry: Codable {
    let characterId: String
}
