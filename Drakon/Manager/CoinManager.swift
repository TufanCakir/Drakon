//
//  CoinManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class CoinManager: ObservableObject {

    static let shared = CoinManager()

    @Published private(set) var coins: Int = 0

    private let key = "drakon_coins"

    private init() {
        load()
    }

    func reset() {
        coins = 0
        save()
    }

    // MARK: Add

    func add(_ amount: Int) {

        guard amount > 0 else { return }

        coins += amount

        save()
    }

    // MARK: Spend

    @discardableResult
    func spend(_ amount: Int) -> Bool {

        guard coins >= amount else { return false }

        coins -= amount

        save()

        return true
    }

    // MARK: Save

    private func save() {

        UserDefaults.standard.set(
            coins,
            forKey: key
        )
    }

    // MARK: Load

    private func load() {

        coins =
            UserDefaults.standard.integer(
                forKey: key
            )
    }
}
