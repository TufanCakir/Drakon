//
//  PassProgressManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class PassProgressManager: ObservableObject {
    static let shared = PassProgressManager()

    @Published private(set) var points: Int = 0
    @Published private(set) var claimedRewardIds: Set<String> = []

    private let pointsKey = "drakon_pass_points"
    private let claimedKey = "drakon_pass_claimed"

    private init() {
        points = UserDefaults.standard.integer(forKey: pointsKey)
        claimedRewardIds = Set(
            UserDefaults.standard.stringArray(forKey: claimedKey) ?? []
        )
    }

    func addPoints(_ amount: Int) {
        points += max(0, amount)
        save()
    }

    func canClaim(tier: Int, pointsPerTier: Int, lane: String) -> Bool {
        points >= tier * pointsPerTier && !isClaimed(tier: tier, lane: lane)
    }

    func isClaimed(tier: Int, lane: String) -> Bool {
        claimedRewardIds.contains(rewardId(tier: tier, lane: lane))
    }

    func claim(tier: Int, lane: String) {
        claimedRewardIds.insert(rewardId(tier: tier, lane: lane))
        save()
    }

    func reset() {
        points = 0
        claimedRewardIds.removeAll()
        save()
    }

    private func rewardId(tier: Int, lane: String) -> String {
        "\(lane)_\(tier)"
    }

    private func save() {
        UserDefaults.standard.set(points, forKey: pointsKey)
        UserDefaults.standard.set(Array(claimedRewardIds), forKey: claimedKey)
    }
}
