//
//  EventCurrencyManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class EventCurrencyManager: ObservableObject {
    static let shared = EventCurrencyManager()

    @Published private(set) var tokens: Int = 0

    private let key = "drakon_event_tokens"

    private init() {
        tokens = UserDefaults.standard.integer(forKey: key)
    }

    func add(_ amount: Int) {
        tokens += max(0, amount)
        save()
    }

    func spend(_ amount: Int) -> Bool {
        guard tokens >= amount else { return false }
        tokens -= amount
        save()
        return true
    }

    func reset() {
        tokens = 0
        save()
    }

    private func save() {
        UserDefaults.standard.set(tokens, forKey: key)
    }
}
