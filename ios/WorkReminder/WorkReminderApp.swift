import SwiftData
import SwiftUI

@main
struct WorkReminderApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: ReminderItem.self)
    }
}
