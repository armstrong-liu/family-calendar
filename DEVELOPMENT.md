# 开发指南

## 快速开始

### 1. 打开项目
```bash
cd /Users/armstrong/code/github/FamilyCalendarApp
open FamilyCalendar.xcodeproj
```

### 2. 配置开发团队
在 Xcode 中：
1. 选择项目 → TARGETS → FamilyCalendar
2. 在 "Signing & Capabilities" 中
3. 选择你的开发团队 (Team)

### 3. 启用 capabilities
在 "Signing & Capabilities" 中添加：
- CloudKit
- Sign in with Apple
- Push Notifications
- Background Modes (Remote notifications)

### 4. 配置 CloudKit
1. 访问 [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard)
2. 创建容器：`iCloud.com.familycalendar.app`
3. 更新 `CloudKitManager.swift` 中的 container ID

### 5. 运行
选择模拟器或真机，点击 Run (⌘R)

## 开发规范

### 代码风格
- 使用 4 空格缩进
- 遵循 Swift 命名规范
- 添加适当的注释
- 函数长度不超过 50 行
- 文件组织遵循 MVVM 架构

### Git 工作流
```bash
# 创建功能分支
git checkout -b feature/new-feature

# 提交更改
git add .
git commit -m "feat: add new feature"

# 推送到远程
git push origin feature/new-feature
```

### Commit 规范
遵循 Conventional Commits：
- `feat:` 新功能
- `fix:` Bug 修复
- `docs:` 文档更新
- `style:` 代码格式
- `refactor:` 重构
- `test:` 测试相关
- `chore:` 构建/工具

## 调试技巧

### 查看 CloudKit 数据
1. 打开 CloudKit Dashboard
2. 选择容器 → CloudKit Console
3. 查看数据库记录

### 模拟推送通知
在 Xcode 中：
1. Debug → Simulate Push Notification
2. 输入 JSON payload

### 查看 UserDefaults
```swift
print(UserDefaults.standard.dictionaryRepresentation())
```

## 测试

### 单元测试
```bash
xcodebuild test \
  -scheme FamilyCalendar \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### UI 测试
```bash
xcodebuild test \
  -scheme FamilyCalendarUITests \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 性能优化

### Instruments 工具
- Time Profiler: CPU 使用
- Allocations: 内存分配
- Leaks: 内存泄漏
- Network: 网络请求

### 优化建议
1. 减少 CloudKit 查询次数
2. 使用缓存策略
3. 优化图片大小
4. 延迟加载非关键资源

## 发布流程

### 1. 版本更新
更新版本号：
- `Info.plist`: CFBundleShortVersionString
- `Constants.swift`: AppConstants.appVersion

### 2. 构建 Archive
```bash
./build.sh archive
```

### 3. 上传到 App Store Connect
使用 Xcode Organizer 或 Transporter

### 4. 提交审核
填写审核信息，提交审核

## 常见问题

### Q: CloudKit 同步失败？
A: 检查 container ID 是否正确，确保已启用 CloudKit capability

### Q: 推送通知收不到？
A: 检查推送证书，确认用户已授权通知权限

### Q: Sign in with Apple 失败？
A: 确保在 Apple Developer 配置了 Sign in with Apple

## 资源链接

- [Apple Developer](https://developer.apple.com/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
