import Foundation
import SwiftData

enum ReminderType: String, Codable, CaseIterable {
    case reminder
    case note
}

enum RepeatRule: String, Codable, CaseIterable {
    case none
    case daily
    case weekly
    case monthly
}

@Model
final class ReminderItem {
    var id: UUID
    var title: String
    var rawText: String
    var note: String?
    var typeRawValue: String
    var remindAt: Date?
    var repeatRuleRawValue: String
    var isCompleted: Bool
    var completedAt: Date?
    var notificationId: String?
    var createdAt: Date
    var updatedAt: Date

    var type: ReminderType {
        get { ReminderType(rawValue: typeRawValue) ?? .reminder }
        set { typeRawValue = newValue.rawValue }
    }

    var repeatRule: RepeatRule {
        get { RepeatRule(rawValue: repeatRuleRawValue) ?? .none }
        set { repeatRuleRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        title: String,
        rawText: String,
        note: String? = nil,
        type: ReminderType,
        remindAt: Date?,
        repeatRule: RepeatRule = .none,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        notificationId: String? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.rawText = rawText
        self.note = note
        self.typeRawValue = type.rawValue
        self.remindAt = remindAt
        self.repeatRuleRawValue = repeatRule.rawValue
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.notificationId = notificationId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
