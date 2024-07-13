import SwiftUI

@main
struct SolervisApp: App {
    @StateObject private var userSettings = UserSettings()

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(userSettings)
            }
        }
}
