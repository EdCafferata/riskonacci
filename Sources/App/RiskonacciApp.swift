import SwiftUI
import FirebaseCore

@main
struct RiskonacciApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
