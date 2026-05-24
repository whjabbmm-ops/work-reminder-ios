# 工作提醒 App

个人自用的 iOS 本地工作提醒记录工具。

目标是用一句话快速创建提醒或工作记录，例如：

- 明天下午三点提醒我给客户发报价
- 下周一上午十点跟进合同
- 每天下午六点记录今天完成了什么
- 半小时后提醒我回电话

第一版坚持三个原则：

- 无服务器、无账号，数据只保存在本机
- 语音输入优先，手动修改兜底
- 功能克制，只解决日常工作提醒和记录

## 当前文件

- `wireframe-preview.html`：同事预览用的商务风格草图
- `docs/product-spec.md`：第一版产品需求说明
- `docs/ios-tech-design.md`：iOS 原生实现方案
- `docs/iphone-deployment.md`：iPhone 真机安装和测试方案
- `docs/mac-xcode-beginner-guide.md`：Mac + Xcode 新手操作手册
- `ios/WorkReminder`：SwiftUI 第一版源码骨架

## MVP 范围

- 今日提醒列表
- 新增提醒
- 语音输入
- 中文时间解析
- 本地通知
- 工作记录
- 完成、删除、延后
- 本地存储

## 暂不做

- 登录注册
- 云同步
- 多人协作
- Web 管理端
- 服务器推送
- AI 云端解析

## iOS 开发说明

当前环境是 Windows，不能直接生成和编译 Xcode 工程。`ios/WorkReminder` 里已经准备好 SwiftUI 源码骨架。

在 Mac 上继续开发时：

1. 用 Xcode 新建 iOS App 项目，名称建议 `WorkReminder`
2. 勾选 SwiftUI，数据存储选择 SwiftData
3. 把 `ios/WorkReminder` 下的 Swift 文件迁入项目
4. 合并 `Info.plist` 里的麦克风和语音识别权限说明
5. 真机测试语音识别和本地通知

## iPhone 使用路径

第一版建议先用 Xcode 直接安装到自己的 iPhone 上测试。稳定后，如果需要更长期或让同事试用，再走 TestFlight。

详细步骤见 `docs/iphone-deployment.md`。
