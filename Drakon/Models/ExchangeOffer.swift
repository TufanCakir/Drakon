//
//  ExchangeOffer.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

struct ExchangeOffer: Codable, Identifiable {

    let id: String
    let title: String

    // 🟡 NORMAL
    let coinCost: Int?
    let gemReward: Int?

    let purchaseLimit: Int
}
