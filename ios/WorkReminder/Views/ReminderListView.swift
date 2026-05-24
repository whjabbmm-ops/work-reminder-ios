import SwiftData
import SwiftUI

struct ReminderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ReminderItem.remindAt) private var items: [ReminderItem]
    @State private var isConfirmingVoiceInput = false
    @State private var parsedReminder: ParsedReminder?

    private let parser = ReminderParser()

    var body: some View {
        NavigationStack {
            List {
                Section("待提醒") {
                    ForEach(activeItems) { item in
                        ReminderRow(item: item) {
                            complete(item)
                        }
                    }
                    .onDelete(perform: delete)
                }

                Section("已完成") {
                    ForEach(completedItems) { item in
                        ReminderRow(item: item, onComplete: {})
                    }
                }
            }
            .navigationTitle("今天")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        parsedReminder = parser.parse("明天下午三点提醒我给客户发报价")
                        isConfirmingVoiceInput = true
                    } label: {
                        Image(systemName: "mic.fill")
                    }
                }
            }
            .sheet(isPresented: $isConfirmingVoiceInput) {
                if let parsedReminder {
                    ConfirmReminderView(parsed: parsedReminder)
                }
            }
        }
    }

    private var activeItems: [ReminderItem] {
        items.filter { !$0.isCompleted }
    }

    private var completedItems: [ReminderItem] {
        items.filter(\.isCompleted)
    }

    private func complete(_ item: ReminderItem) {
        item.isCompleted = true
        item.completedAt = .now
        item.updatedAt = .now
        NotificationScheduler.shared.cancel(notificationId: item.notificationId)
    }

    private func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            let item = activeItems[index]
            NotificationScheduler.shared.cancel(notificationId: item.notificationId)
            modelContext.delete(item)
        }
    }
}
