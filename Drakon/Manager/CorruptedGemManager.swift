//
//  CorruptedGemManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 17.03.26.
//

import Combine
import Foundation

final class CorruptedGemManager: ObservableObject {

    static let shared = CorruptedGemManager()

    @Published private(set) var gems: Int = 0

    private let key = "drakon_corrupted_gems"

    private init() {
        load()
    }

    func spend(_ amount: Int) -> Bool {
        guard amount > 0, gems >= amount else { return false }
        gems -= amount
        save()
        return true
    }

    func add(_ amount: Int) {
        guard amount > 0 else { return }
        gems += amount
        save()
    }

    func reset() {
        gems = 0
        save()
    }

    private func save() {
        UserDefaults.standard.set(gems, forKey: key)
    }

    private func load() {
        gems = UserDefaults.standard.integer(forKey: key)
    }
}
