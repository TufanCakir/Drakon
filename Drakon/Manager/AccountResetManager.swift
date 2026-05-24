//
//  AccountResetManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

final class AccountResetManager {

    static func resetAll() {

        let defaults = UserDefaults.standard

        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }

        defaults.synchronize()
    }
}
