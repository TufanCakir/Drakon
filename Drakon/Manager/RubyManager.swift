//
//  RubyManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class RubyManager: ObservableObject {
    static let shared = RubyManager()

    @Published private(set) var rubies: Int = 0

    private let key = "drakon_rubies"

    private init() {
        rubies = UserDefaults.standard.integer(forKey: key)
    }

    func add(_ amount: Int) {
        rubies += max(0, amount)
        save()
    }

    func spend(_ amount: Int) -> Bool {
        guard rubies >= amount else { return false }
        rubies -= amount
        save()
        return true
    }

    func reset() {
        rubies = 0
        save()
    }

    private func save() {
        UserDefaults.standard.set(rubies, forKey: key)
    }
}
