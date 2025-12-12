//
//  AppLauncherManager.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/12/25.
//

import Foundation

final class AppLauncherManager {

    private let hasLaunchedBeforeKey = "hasLaunchedBefore"
    private let keychainManager = KeychainManager.shared

    func handleFirstLaunchIfNeeded() {
        let defaults = UserDefaults.standard
        let hasLaunchedBefore = defaults.bool(forKey: hasLaunchedBeforeKey)

        if !hasLaunchedBefore {
            // delete token if first install
            keychainManager.deleteToken()

            defaults.set(true, forKey: hasLaunchedBeforeKey)
            defaults.synchronize()
        }
    }
}
