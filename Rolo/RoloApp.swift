

import SwiftUI
import SwiftData

@main
struct RoloApp: App {
    private let appLauncherManager = AppLauncherManager()

    init() {
        appLauncherManager.handleFirstLaunchIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [UserProfile.self])
    }
}
