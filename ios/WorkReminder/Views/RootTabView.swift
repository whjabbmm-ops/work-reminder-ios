import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            ReminderListView()
                .tabItem {
                    Label("提醒", systemImage: "checklist")
                }

            RecordsView()
                .tabItem {
                    Label("记录", systemImage: "doc.text")
                }

            SettingsView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
        }
    }
}
