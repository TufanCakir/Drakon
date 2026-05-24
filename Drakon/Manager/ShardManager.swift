//
//  ShardManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class ShardManager: ObservableObject {
    static let shared = ShardManager()

    @Published private(set) var shards: Int = 0

    private let key = "drakon_shards"

    private init() {
        shards = UserDefaults.standard.integer(forKey: key)
    }

    func add(_ amount: Int) {
        shards += max(0, amount)
        save()
    }

    func spend(_ amount: Int) -> Bool {
        guard shards >= amount else { return false }
        shards -= amount
        save()
        return true
    }

    func reset() {
        shards = 0
        save()
    }

    private func save() {
        UserDefaults.standard.set(shards, forKey: key)
    }
}
