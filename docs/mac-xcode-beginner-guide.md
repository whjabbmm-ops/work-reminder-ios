# Mac + Xcode 新手操作手册

这份说明按“完全没有 iOS 开发经验”的情况写。目标是把工作提醒 App 安装到自己的 iPhone 上测试和使用。

## 你需要准备什么

### 硬件

- 一台 Mac
- 一台 iPhone
- 一根能连接 Mac 和 iPhone 的数据线

如果 Mac 和 iPhone 都登录同一个 Apple ID，后面也可以无线调试，但第一次建议用数据线。

### 账号

- 一个 Apple ID

第一阶段只装到自己的 iPhone 上测试，可以先用普通 Apple ID。  
如果以后要用 TestFlight 给同事试用，通常需要加入 Apple Developer Program。

### 软件

- Xcode

Xcode 从 Mac App Store 安装。安装包很大，建议提前留出足够时间和磁盘空间。

## 总体流程

```text
安装 Xcode
  ↓
新建 iOS App 项目
  ↓
把当前 Swift 源码放进 Xcode 项目
  ↓
配置签名和 Bundle ID
  ↓
配置麦克风、语音识别权限
  ↓
连接 iPhone
  ↓
点击运行
  ↓
iPhone 上授权并测试
```

## 第一步：安装 Xcode

1. 打开 Mac 上的 App Store
2. 搜索 `Xcode`
3. 点击获取或安装
4. 安装完成后打开 Xcode
5. 第一次打开时，Xcode 可能会安装额外组件，点同意并等待完成

如果 Xcode 提示登录 Apple ID，可以先登录。

## 第二步：准备项目文件

你现在 Windows 上的项目目录是：

```text
D:\Users\whj\Documents\提醒app
```

需要把整个文件夹复制到 Mac。

推荐方式：

- 用 U 盘复制
- 用移动硬盘复制
- 用微信/网盘传输压缩包
- 如果你会用 Git，也可以推到仓库再在 Mac 上拉取

复制到 Mac 后，建议放在：

```text
~/Documents/提醒app
```

Mac 上路径大概会像：

```text
/Users/你的用户名/Documents/提醒app
```

## 第三步：新建 Xcode 项目

1. 打开 Xcode
2. 选择 `Create New Project`
3. 选择 `iOS`
4. 选择 `App`
5. 点击 `Next`

填写项目设置：

```text
Product Name: WorkReminder
Team: 选择你的 Apple ID 对应的团队
Organization Identifier: com.yourname
Interface: SwiftUI
Language: Swift
Storage: SwiftData
```

说明：

- `Product Name` 是 App 名称，建议用 `WorkReminder`
- `Organization Identifier` 可以写类似 `com.whj`
- 最终 Bundle Identifier 会类似 `com.whj.WorkReminder`
- 如果 Xcode 提示 Bundle Identifier 已被占用，就换一个更独特的，比如 `com.whj.local.workreminder`

然后选择保存位置。建议保存到：

```text
~/Documents/提醒app/xcode/WorkReminder
```

## 第四步：把源码加入 Xcode 项目

当前项目里已经准备好的 Swift 文件在：

```text
ios/WorkReminder
```

里面包括：

```text
WorkReminderApp.swift
Models/
Services/
Views/
Info.plist
```

在 Xcode 里操作：

1. 左侧 Project Navigator 里，找到 `WorkReminder` 项目
2. 删除 Xcode 自动生成的默认 `WorkReminderApp.swift` 和 `ContentView.swift`
3. 在左侧项目文件夹上右键
4. 选择 `Add Files to "WorkReminder"...`
5. 找到复制过来的：

```text
提醒app/ios/WorkReminder
```

6. 选中里面的 Swift 文件和文件夹
7. 勾选 `Copy items if needed`
8. 勾选目标 Target：`WorkReminder`
9. 点击 `Add`

注意：

- `Info.plist` 不一定要直接替换 Xcode 自动生成的配置
- 重点是把里面的权限文字加到 Xcode 项目配置中

## 第五步：配置权限说明

这个 App 需要三个权限：

- 麦克风
- 语音识别
- 通知

通知权限代码里会请求，不一定需要 Info.plist 文案。  
麦克风和语音识别需要在 Info.plist 中配置。

### 方法一：在 Xcode 界面添加

1. 点击左侧最上面的项目 `WorkReminder`
2. 选择中间的 Target：`WorkReminder`
3. 找到 `Info`
4. 在 Custom iOS Target Properties 里添加：

```text
Privacy - Microphone Usage Description
用于通过语音创建工作提醒和记录。

Privacy - Speech Recognition Usage Description
用于将语音内容识别为提醒文本。
```

### 方法二：编辑 Info.plist

如果你能看到 `Info.plist`，也可以加入：

```xml
<key>NSMicrophoneUsageDescription</key>
<string>用于通过语音创建工作提醒和记录。</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>用于将语音内容识别为提醒文本。</string>
```

## 第六步：配置签名

1. 点击左侧最上面的项目 `WorkReminder`
2. 选择 Target：`WorkReminder`
3. 打开 `Signing & Capabilities`
4. 勾选 `Automatically manage signing`
5. Team 选择你的 Apple ID
6. Bundle Identifier 填一个唯一值，例如：

```text
com.whj.local.workreminder
```

如果出现红色错误，常见原因：

- 没登录 Apple ID
- Bundle Identifier 已经被别人用了
- iPhone 没连接或没信任
- Xcode 还没完成组件安装

优先尝试：

- 换一个更独特的 Bundle Identifier
- 重新插拔 iPhone
- Xcode 设置里重新登录 Apple ID

## 第七步：连接 iPhone

1. 用数据线连接 iPhone 和 Mac
2. iPhone 弹出“是否信任此电脑”，点 `信任`
3. 输入 iPhone 锁屏密码
4. Xcode 顶部运行设备那里，选择你的 iPhone

如果没有看到 iPhone：

- 确认线支持数据传输，不只是充电线
- iPhone 保持解锁
- Xcode 顶部菜单选择 `Window > Devices and Simulators`
- 看看设备是否出现在列表里

## 第八步：第一次运行

1. 在 Xcode 顶部选择你的 iPhone
2. 点击左上角三角形运行按钮
3. 等待编译
4. Xcode 会把 App 安装到 iPhone

第一次可能会失败，这是正常的。常见情况如下。

### 情况一：iPhone 提示不信任开发者

在 iPhone 上打开：

```text
设置 > 通用 > VPN与设备管理
```

找到你的 Apple ID 开发者证书，选择信任。

然后回到 Xcode 再运行一次。

### 情况二：Xcode 提示签名错误

检查：

- Team 是否选了你的 Apple ID
- Automatically manage signing 是否勾选
- Bundle Identifier 是否唯一
- iPhone 是否连接并信任

### 情况三：编译报代码错误

把错误截图或复制给我，我可以继续帮你修。

## 第九步：在 iPhone 上授权

App 第一次运行时，会陆续请求：

- 麦克风权限
- 语音识别权限
- 通知权限

都选择允许。

如果不小心点了不允许，可以去：

```text
设置 > App > WorkReminder
```

或：

```text
设置 > 隐私与安全性
```

重新开启相关权限。

## 第十步：真机测试

先测最简单的：

1. 打开 App
2. 新建提醒
3. 保存
4. 看列表是否出现
5. 设置一个 1 分钟后的提醒
6. 锁屏等待通知

再测语音句子：

```text
明天下午三点提醒我给客户发报价
半小时后提醒我回电话
两个小时后提醒我看合同
每天晚上六点提醒我写日报
后天上午十点提醒我开票
```

测试点：

- 能不能识别语音
- 时间解析是否正确
- 保存后是否出现在列表
- 到点是否弹通知
- 完成后是否不再提醒
- 删除后是否取消通知

## 第十一步：每天自己用的方式

第一版建议你先这样用：

1. 想到事情，打开 App
2. 点语音按钮
3. 说一句完整提醒
4. 确认解析结果
5. 保存

语音解析不准时，就手动改一下时间或内容。

## 如果想长期稳定使用

用 Xcode 直接安装适合第一阶段测试。  
如果你想长期稳定使用，后续建议走 TestFlight。

TestFlight 大概流程：

```text
加入 Apple Developer Program
  ↓
在 App Store Connect 创建 App
  ↓
Xcode Archive
  ↓
上传到 App Store Connect
  ↓
开启 TestFlight
  ↓
用 TestFlight 安装到 iPhone
```

这一步比直接安装复杂，可以等第一版 App 真机跑通后再做。

## 给新手的建议

第一次不要追求一步到位。

推荐顺序：

1. 先让 Xcode 空白 App 跑到 iPhone 上
2. 再加入当前项目源码
3. 再测试本地存储
4. 再测试通知
5. 最后测试语音

这样每一步出错都比较容易定位。

## 遇到问题时给我什么信息

如果卡住，把下面信息发给我：

- Xcode 报错截图
- 左侧文件结构截图
- Signing & Capabilities 截图
- iPhone 系统版本
- Xcode 版本
- 你卡在哪一步

我可以按错误继续带你处理。
