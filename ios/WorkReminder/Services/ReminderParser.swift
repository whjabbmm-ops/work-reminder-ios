import Foundation

struct ParsedReminder {
    var title: String
    var rawText: String
    var remindAt: Date?
    var repeatRule: RepeatRule
    var confidence: Double

    var type: ReminderType {
        remindAt == nil ? .note : .reminder
    }
}

struct ReminderParser {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func parse(_ text: String, now: Date = .now) -> ParsedReminder {
        let normalized = normalize(text)
        let repeatRule = parseRepeatRule(normalized)
        let remindAt = parseRemindDate(normalized, now: now)
        let title = cleanTitle(normalized)

        return ParsedReminder(
            title: title.isEmpty ? normalized : title,
            rawText: text,
            remindAt: remindAt,
            repeatRule: repeatRule,
            confidence: remindAt == nil ? 0.5 : 0.8
        )
    }

    private func normalize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "，", with: "")
            .replacingOccurrences(of: "。", with: "")
    }

    private func parseRepeatRule(_ text: String) -> RepeatRule {
        if text.contains("每天") || text.contains("每日") {
            return .daily
        }
        if text.contains("每周") || text.contains("每星期") {
            return .weekly
        }
        if text.contains("每月") {
            return .monthly
        }
        return .none
    }

    private func parseRemindDate(_ text: String, now: Date) -> Date? {
        if let relative = parseRelativeOffset(text, now: now) {
            return relative
        }

        let baseDate = parseBaseDate(text, now: now)
        guard let hourMinute = parseHourMinute(text) else {
            return nil
        }

        return calendar.date(
            bySettingHour: hourMinute.hour,
            minute: hourMinute.minute,
            second: 0,
            of: baseDate
        )
    }

    private func parseRelativeOffset(_ text: String, now: Date) -> Date? {
        if text.contains("半小时后") || text.contains("半个小时后") {
            return calendar.date(byAdding: .minute, value: 30, to: now)
        }

        if let hours = firstChineseNumberBefore(text, suffix: "小时后") {
            return calendar.date(byAdding: .hour, value: hours, to: now)
        }

        if let minutes = firstChineseNumberBefore(text, suffix: "分钟后") {
            return calendar.date(byAdding: .minute, value: minutes, to: now)
        }

        return nil
    }

    private func parseBaseDate(_ text: String, now: Date) -> Date {
        if text.contains("后天") {
            return calendar.date(byAdding: .day, value: 2, to: now) ?? now
        }
        if text.contains("明天") {
            return calendar.date(byAdding: .day, value: 1, to: now) ?? now
        }
        return now
    }

    private func parseHourMinute(_ text: String) -> (hour: Int, minute: Int)? {
        let pattern = #"([零一二三四五六七八九十两\d]{1,3})(点|时)(半|[零一二三四五六七八九十两\d]{1,2}分?)?"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
              let hourRange = Range(match.range(at: 1), in: text) else {
            return nil
        }

        var hour = numberValue(String(text[hourRange]))
        var minute = 0

        if match.range(at: 3).location != NSNotFound,
           let minuteRange = Range(match.range(at: 3), in: text) {
            let minuteText = String(text[minuteRange])
            minute = minuteText == "半" ? 30 : numberValue(minuteText.replacingOccurrences(of: "分", with: ""))
        }

        if text.contains("下午") || text.contains("晚上") || text.contains("傍晚") {
            if hour < 12 {
                hour += 12
            }
        }

        return (hour, minute)
    }

    private func cleanTitle(_ text: String) -> String {
        var result = text
        let removable = [
            "提醒我", "帮我", "记一下", "提醒", "今天", "明天", "后天",
            "上午", "中午", "下午", "晚上", "早上", "每天", "每日", "每周", "每月"
        ]

        for token in removable {
            result = result.replacingOccurrences(of: token, with: "")
        }

        if let regex = try? NSRegularExpression(pattern: #"([零一二三四五六七八九十两\d]{1,3})(点|时)(半|[零一二三四五六七八九十两\d]{1,2}分?)?"#) {
            result = regex.stringByReplacingMatches(
                in: result,
                range: NSRange(result.startIndex..., in: result),
                withTemplate: ""
            )
        }

        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func firstChineseNumberBefore(_ text: String, suffix: String) -> Int? {
        guard let suffixRange = text.range(of: suffix) else {
            return nil
        }

        let prefix = String(text[..<suffixRange.lowerBound])
        let candidates = prefix.suffix(4)
        let digits = candidates.filter { "零一二三四五六七八九十两0123456789".contains($0) }
        return digits.isEmpty ? nil : numberValue(String(digits))
    }

    private func numberValue(_ text: String) -> Int {
        if let value = Int(text) {
            return value
        }

        let values: [Character: Int] = [
            "零": 0, "一": 1, "二": 2, "两": 2, "三": 3, "四": 4,
            "五": 5, "六": 6, "七": 7, "八": 8, "九": 9
        ]

        if text == "十" {
            return 10
        }

        if text.contains("十") {
            let parts = text.split(separator: "十", omittingEmptySubsequences: false)
            let tens = parts.first?.first.flatMap { values[$0] } ?? 1
            let ones = parts.count > 1 ? (parts[1].first.flatMap { values[$0] } ?? 0) : 0
            return tens * 10 + ones
        }

        return text.first.flatMap { values[$0] } ?? 0
    }
}
