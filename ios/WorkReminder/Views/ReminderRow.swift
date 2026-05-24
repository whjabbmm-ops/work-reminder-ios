import SwiftUI

struct ReminderRow: View {
    let item: ReminderItem
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                if let remindAt = item.remindAt {
                    Text(remindAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(remindAt, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("普通记录")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if !item.isCompleted {
                Button("完成", action: onComplete)
                    .buttonStyle(.bordered)
            }
        }
        .padding(.vertical, 4)
    }
}
