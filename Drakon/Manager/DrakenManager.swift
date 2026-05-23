//
//  DrakenManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Combine
import Foundation

final class DrakenManager: ObservableObject {
    static let shared = DrakenManager()

    @Published private(set) var draken: Int = 0

    private let key = "drakon_draken"

    private init() {
        draken = UserDefaults.standard.integer(forKey: key)
    }

    func add(_ amount: Int) {
        draken += max(0, amount)
        save()
    }

    func spend(_ amount: Int) -> Bool {
        guard draken >= amount else { return false }
        draken -= amount
        save()
        return true
    }

    func reset() {
        draken = 0
        save()
    }

    private func save() {
        UserDefaults.standard.set(draken, forKey: key)
    }
}
