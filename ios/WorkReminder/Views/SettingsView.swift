import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("权限") {
                    Label("本地通知", systemImage: "bell")
                    Label("语音识别", systemImage: "mic")
                }

                Section("默认延后") {
                    Text("10 分钟后")
                    Text("1 小时后")
                    Text("明天上午 9 点")
                }

                Section("数据") {
                    Text("数据仅保存在本机，不上传服务器。")
                }
            }
            .navigationTitle("设置")
        }
    }
}
