# iOS 技术设计

## 技术选型

- UI：SwiftUI
- 本地数据：SwiftData
- 本地通知：UserNotifications
- 语音识别：Speech framework
- 录音权限：AVFoundation
- 最低系统建议：iOS 17

不使用服务器，不接入账号系统，不依赖云端数据库。

## 模块划分

```text
App
├─ Features
│  ├─ Reminders
│  ├─ Records
│  ├─ VoiceInput
│  └─ Settings
├─ Models
├─ Services
│  ├─ SpeechRecognitionService
│  ├─ ReminderParser
│  ├─ NotificationScheduler
│  └─ SnoozeService
└─ Shared
```

## 数据模型

```swift
@Model
final class ReminderItem {
    var id: UUID
    var title: String
    var rawText: String
    var note: String?
    var type: ReminderType
    var remindAt: Date?
    var repeatRule: RepeatRule
    var isCompleted: Bool
    var completedAt: Date?
    var notificationId: String?
    var createdAt: Date
    var updatedAt: Date
}
```

### ReminderType

```swift
enum ReminderType: String, Codable {
    case reminder
    case note
}
```

### RepeatRule

```swift
enum RepeatRule: String, Codable {
    case none
    case daily
    case weekly
    case monthly
}
```

## 语音识别流程

```text
VoiceInputView
  ↓
SpeechRecognitionService.start()
  ↓
SFSpeechRecognizer 输出文本
  ↓
ReminderParser.parse(text)
  ↓
ConfirmReminderView
  ↓
保存 SwiftData
  ↓
NotificationScheduler.schedule()
```

## 权限

需要在 `Info.plist` 中配置：

```text
NSSpeechRecognitionUsageDescription
NSMicrophoneUsageDescription
```

运行时请求：

- `SFSpeechRecognizer.requestAuthorization`
- `AVAudioSession` 麦克风权限
- `UNUserNotificationCenter.requestAuthorization`

## 时间解析策略

第一版使用本地规则解析，不调用云端 AI。

解析结果结构：

```swift
struct ParsedReminder {
    var title: String
    var rawText: String
    var remindAt: Date?
    var repeatRule: RepeatRule
    var confidence: Double
}
```

### 解析优先级

1. 重复规则：每天、每周、每月
2. 相对时间：半小时后、两小时后、明天、后天、下周
3. 具体日期：5月25号、2026年5月25日
4. 时段修正：上午、下午、晚上、早上
5. 内容清洗：移除“提醒我”“帮我”“记一下”等提示词

## 通知调度

一次性提醒使用：

```swift
UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
```

重复提醒使用：

```swift
UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
```

完成或删除提醒时，需要取消对应通知：

```swift
UNUserNotificationCenter.current()
    .removePendingNotificationRequests(withIdentifiers: [notificationId])
```

## 延后规则

默认提供：

- 10 分钟后
- 1 小时后
- 明天上午 9 点

延后时：

1. 更新 `remindAt`
2. 取消旧通知
3. 创建新通知

## 页面结构

### ReminderListView

- 今日提醒
- 待提醒列表
- 已完成列表
- 语音输入入口

### ConfirmReminderView

- 原始语音文本
- 解析后的标题
- 解析后的提醒时间
- 重复规则
- 保存、修改、重新录音

### EditReminderView

- 内容
- 时间
- 重复
- 备注
- 删除

### RecordsView

- 搜索
- 日期分组记录
- 普通记录和已完成提醒

### SettingsView

- 通知权限
- 语音权限
- 默认延后选项
- 数据说明

## 错误处理

### 语音识别失败

提示用户重新录音，并保留手动输入入口。

### 时间解析失败

如果内容有效：

- 默认保存为普通记录
- 或展示“选择提醒时间”按钮

### 通知权限未开启

允许保存提醒，但提示用户需要开启通知权限，否则不会弹系统提醒。

## 后续可扩展

- CSV 或文本导出
- iCloud 本地同步
- 日历集成
- 自定义重复规则
- 快捷指令入口
- 桌面小组件
