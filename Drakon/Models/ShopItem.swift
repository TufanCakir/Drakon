//
//  ShopItem.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

struct ShopItem: Codable, Identifiable {

    let id: String
    let storeProductId: String?
    let category: ShopCategory

    let gems: Int?
    let rubies: Int?
    let draken: Int?
    let shards: Int?
    let eventCurrency: Int?

    let oneTimePurchase: Bool?
    let tag: String?
}

extension ShopItem {
    var rewardAmount: Int {
        gems ?? rubies ?? draken ?? shards ?? eventCurrency ?? 0
    }

    var rewardTitle: String {
        if gems != nil { return "GEMS" }
        if rubies != nil { return "RUBY" }
        if draken != nil { return "DRAKEN" }
        if shards != nil { return "SHARDS" }
        if eventCurrency != nil { return "EVENT" }
        return "REWARD"
    }

    var rewardIcon: String {
        if gems != nil { return "icon_drakon_gem" }
        if rubies != nil { return "icon_drakon_ruby" }
        if draken != nil { return "icon_draken" }
        if shards != nil { return "icon_drakon_shard" }
        if eventCurrency != nil { return "icon_drakon_shard" }
        return "drakon_icon"
    }
}
