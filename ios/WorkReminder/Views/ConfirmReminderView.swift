import SwiftData
import SwiftUI

struct ConfirmReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let parsed: ParsedReminder

    var body: some View {
        NavigationStack {
            Form {
                Section("语音文本") {
                    Text(parsed.rawText)
                }

                Section("解析结果") {
                    LabeledContent("内容", value: parsed.title)
                    if let remindAt = parsed.remindAt {
                        LabeledContent("时间") {
                            Text(remindAt.formatted(date: .numeric, time: .shortened))
                        }
                    } else {
                        LabeledContent("类型", value: "普通记录")
                    }
                    LabeledContent("重复", value: parsed.repeatRule.rawValue)
                }
            }
            .navigationTitle("确认提醒")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        save()
                    }
                }
            }
        }
    }

    private func save() {
        let item = ReminderItem(
            title: parsed.title,
            rawText: parsed.rawText,
            type: parsed.type,
            remindAt: parsed.remindAt,
            repeatRule: parsed.repeatRule
        )

        modelContext.insert(item)

        Task {
            item.notificationId = try? await NotificationScheduler.shared.schedule(for: item)
            item.updatedAt = .now
            dismiss()
        }
    }
}
