import Foundation
import UserNotifications

final class NotificationScheduler {
    static let shared = NotificationScheduler()

    private init() {}

    func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
    }

    func schedule(for item: ReminderItem) async throws -> String? {
        guard let remindAt = item.remindAt else {
            return nil
        }

        let id = item.notificationId ?? item.id.uuidString
        let content = UNMutableNotificationContent()
        content.title = "工作提醒"
        content.body = item.title
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .weekday, .hour, .minute],
            from: remindAt
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: componentsForTrigger(components, repeatRule: item.repeatRule),
            repeats: item.repeatRule != .none
        )

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        return id
    }

    func cancel(notificationId: String?) {
        guard let notificationId else {
            return
        }

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [notificationId])
    }

    private func componentsForTrigger(_ components: DateComponents, repeatRule: RepeatRule) -> DateComponents {
        switch repeatRule {
        case .none:
            return components
        case .daily:
            return DateComponents(hour: components.hour, minute: components.minute)
        case .weekly:
            return DateComponents(weekday: components.weekday, hour: components.hour, minute: components.minute)
        case .monthly:
            return DateComponents(day: components.day, hour: components.hour, minute: components.minute)
        }
    }
}
