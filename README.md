# 家庭日历 (Family Calendar)

一款专为家庭设计的 iOS 日程协作与沟通工具。

## 功能特性

### 核心功能
- ✅ **共享日历** - 家庭成员可以共享日历，查看所有事项
- ✅ **事项管理** - 创建、编辑、删除事项
- ✅ **通知推送** - 新事项和更新即时推送通知
- ✅ **快速响应** - 一键同意或拒绝事项邀请
- ✅ **家庭管理** - 创建家庭，邀请成员加入
- ✅ **分类标签** - 多种事项分类（聚餐、出行、购物等）

### 技术特性
- Swift 5.9+
- SwiftUI + UIKit 混合架构
- CloudKit 数据同步
- APNs 推送通知
- Sign in with Apple 身份认证
- iOS 16.0+

## 项目结构

```
FamilyCalendarApp/
├── FamilyCalendar/
│   ├── Models/              # 数据模型
│   │   ├── User.swift
│   │   ├── Family.swift
│   │   ├── Event.swift
│   │   ├── EventParticipant.swift
│   │   ├── Comment.swift
│   │   └── Notification.swift
│   │
│   ├── Views/               # 视图
│   │   ├── LoginView.swift
│   │   ├── CalendarView.swift
│   │   ├── CreateEventView.swift
│   │   ├── EventDetailView.swift
│   │   ├── FamilyView.swift
│   │   ├── NotificationView.swift
│   │   ├── SettingsView.swift
│   │   └── MainTabView.swift
│   │
│   ├── ViewModels/          # 视图模型
│   │   ├── CalendarViewModel.swift
│   │   ├── EventDetailViewModel.swift
│   │   ├── CreateEventViewModel.swift
│   │   └── FamilyViewModel.swift
│   │
│   ├── Services/            # 服务
│   │   ├── CloudKitManager.swift
│   │   ├── NotificationService.swift
│   │   └── AuthService.swift
│   │
│   ├── Repositories/        # 数据仓储
│   │   ├── EventRepository.swift
│   │   ├── FamilyRepository.swift
│   │   └── UserRepository.swift
│   │
│   ├── Utils/               # 工具
│   │   ├── Extensions.swift
│   │   ├── Constants.swift
│   │   └── Helpers.swift
│   │
│   ├── Resources/           # 资源
│   │   ├── Info.plist
│   │   └── Entitlements.plist
│   │
│   └── FamilyCalendarApp.swift
│
└── README.md
```

## 开发环境设置

### 前置要求
- Xcode 15.0+
- iOS 16.0+ SDK
- Apple Developer Account（用于 CloudKit 和 Sign in with Apple）

### 配置步骤

1. **克隆项目**
```bash
cd /Users/armstrong/code/github/FamilyCalendarApp
```

2. **配置 CloudKit**
   - 在 Apple Developer 创建 App ID
   - 启用 CloudKit capability
   - 在 CloudKit Dashboard 创建容器
   - 更新 `CloudKitManager.swift` 中的 container ID

3. **配置 Sign in with Apple**
   - 在 Apple Developer 启用 Sign in with Apple
   - 配置 Entitlements.plist

4. **配置推送通知**
   - 在 Apple Developer 创建推送证书
   - 在 Xcode 启用 Push Notifications capability

5. **打开项目**
```bash
open FamilyCalendar.xcodeproj
```

## 主要功能说明

### 日历模块
- 月视图展示
- 点击日期查看当日事项
- 创建/编辑/删除事项
- 事项分类和提醒

### 家庭模块
- 创建/加入家庭
- 邀请成员（二维码/邀请码）
- 成员管理
- 权限控制（管理员/普通成员）

### 通知模块
- 新事项邀请通知
- 事项更新通知
- 事项提醒通知
- 响应状态通知
- 免打扰模式

### 响应模块
- 同意/拒绝事项邀请
- 添加留言
- 查看响应状态
- 响应统计

## 数据模型

### User（用户）
- id, phoneNumber, appleID, nickname, avatarURL

### Family（家庭）
- id, name, adminID, inviteCode, memberCount

### Event（事项）
- id, familyID, creatorID, title, description, location, startDate, endDate, category

### EventParticipant（事项参与）
- id, eventID, userID, status, comment

## API 设计

### CloudKit Records
- `User`: 用户信息
- `Family`: 家庭信息
- `FamilyMember`: 家庭成员关系
- `Event`: 事项
- `EventParticipant`: 事项参与记录

## 架构模式

采用 MVVM + Clean Architecture：

```
View → ViewModel → UseCase → Repository → CloudKit
```

## 测试

### 单元测试
```bash
xcodebuild test -scheme FamilyCalendar -destination 'platform=iOS Simulator,name=iPhone 15'
```

### UI测试
```bash
xcodebuild test -scheme FamilyCalendarUITests
```

## 构建和发布

### Debug 构建
```bash
xcodebuild -scheme FamilyCalendar -configuration Debug
```

### Release 构建
```bash
xcodebuild -scheme FamilyCalendar -configuration Release archive
```

### App Store 上传
```bash
xcrun altool --upload-app --type ios --file FamilyCalendar.ipa
```

## 依赖项

项目使用原生 iOS SDK，无需第三方依赖。

## 性能优化

- CloudKit 增量同步
- 数据缓存策略
- 延迟加载
- 图片压缩

## 安全性

- CloudKit 端到端加密
- Sign in with Apple 认证
- 数据访问控制
- 隐私保护

## 已知问题

- CloudKit 共享数据库限制
- 推送通知延迟
- 多设备同步延迟

## 后续计划

### v1.1
- 周视图、日视图
- 事项评论功能
- Widget 小组件

### v1.2
- 多家庭支持
- Apple Watch 应用
- 系统日历导出

## 贡献指南

欢迎提交 Issue 和 Pull Request。

## 许可证

版权所有 © 2026 FamilyCalendar

## 联系方式

- 网站: https://familycalendar.app
- 邮箱: support@familycalendar.app

---

**让家庭沟通更简单** ❤️
