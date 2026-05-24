import SwiftData
import SwiftUI

struct RecordsView: View {
    @Query(sort: \ReminderItem.createdAt, order: .reverse) private var items: [ReminderItem]
    @State private var query = ""

    var body: some View {
        NavigationStack {
            List(filteredItems) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.createdAt, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if !item.rawText.isEmpty {
                        Text(item.rawText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("记录")
            .searchable(text: $query, prompt: "搜索客户、合同、报价")
        }
    }

    private var filteredItems: [ReminderItem] {
        guard !query.isEmpty else {
            return items
        }
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(query)
                || $0.rawText.localizedCaseInsensitiveContains(query)
        }
    }
}
