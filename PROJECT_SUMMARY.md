# 家庭日历 App - 项目总结

## 📱 项目信息

**项目名称**: 家庭日历 (Family Calendar)
**版本**: 1.0.0
**开发语言**: Swift 5.9+
**最低支持**: iOS 16.0+
**架构**: MVVM + Clean Architecture

---

## ✅ 已完成功能

### 核心模块

#### 1. 数据模型层 (Models)
- ✅ User (用户模型)
- ✅ Family (家庭模型)
- ✅ FamilyMember (家庭成员关系)
- ✅ Event (事项模型)
- ✅ EventParticipant (事项参与)
- ✅ Comment (评论)
- ✅ AppNotification (通知)

#### 2. 数据层 (Services & Repositories)
- ✅ CloudKitManager - CloudKit 数据管理
- ✅ EventRepository - 事项数据仓储
- ✅ FamilyRepository - 家庭数据仓储
- ✅ UserRepository - 用户数据仓储

#### 3. 业务逻辑层 (ViewModels)
- ✅ CalendarViewModel - 日历视图模型
- ✅ EventDetailViewModel - 事项详情视图模型
- ✅ CreateEventViewModel - 创建事项视图模型
- ✅ FamilyViewModel - 家庭视图模型

#### 4. 视图层 (Views)
- ✅ LoginView - 登录视图 (Sign in with Apple)
- ✅ CalendarView - 日历主视图 (月视图)
- ✅ CreateEventView - 创建事项视图
- ✅ EventDetailView - 事项详情视图
- ✅ FamilyView - 家庭管理视图
- ✅ NotificationView - 通知中心视图
- ✅ SettingsView - 设置视图
- ✅ MainTabView - 主标签视图

#### 5. 服务层 (Services)
- ✅ NotificationService - 通知服务
- ✅ AuthService - 认证服务 (Sign in with Apple)

#### 6. 工具类 (Utils)
- ✅ Extensions - Swift 扩展
- ✅ Constants - 应用常量
- ✅ Helpers - 辅助函数

---

## 📂 项目结构

```
FamilyCalendarApp/
├── FamilyCalendar/
│   ├── Models/                    # 数据模型
│   │   ├── User.swift
│   │   ├── Family.swift
│   │   ├── Event.swift
│   │   ├── EventParticipant.swift
│   │   ├── Comment.swift
│   │   └── Notification.swift
│   │
│   ├── Views/                     # 视图
│   │   ├── LoginView.swift
│   │   ├── CalendarView.swift
│   │   ├── CreateEventView.swift
│   │   ├── EventDetailView.swift
│   │   ├── FamilyView.swift
│   │   ├── NotificationView.swift
│   │   ├── SettingsView.swift
│   │   └── MainTabView.swift
│   │
│   ├── ViewModels/                # 视图模型
│   │   ├── CalendarViewModel.swift
│   │   ├── EventDetailViewModel.swift
│   │   ├── CreateEventViewModel.swift
│   │   └── FamilyViewModel.swift
│   │
│   ├── Services/                  # 服务
│   │   ├── CloudKitManager.swift
│   │   ├── NotificationService.swift
│   │   └── AuthService.swift
│   │
│   ├── Repositories/              # 数据仓储
│   │   ├── EventRepository.swift
│   │   ├── FamilyRepository.swift
│   │   └── UserRepository.swift
│   │
│   ├── Utils/                     # 工具
│   │   ├── Extensions.swift
│   │   ├── Constants.swift
│   │   └── Helpers.swift
│   │
│   ├── Resources/                 # 资源
│   │   ├── Info.plist
│   │   ├── Entitlements.plist
│   │   └── Assets.swift
│   │
│   └── FamilyCalendarApp.swift    # App 入口
│
├── README.md                      # 项目说明
├── DEVELOPMENT.md                 # 开发指南
├── CLOUDKIT_SCHEMA.md            # CloudKit Schema
├── build.sh                       # 构建脚本
├── setup.sh                       # 安装脚本
└── PROJECT_SUMMARY.md             # 项目总结
```

---

## 🎯 核心功能

### 1. 用户认证
- ✅ Sign in with Apple 登录
- ✅ 用户信息管理
- ✅ 自动登录状态保持

### 2. 家庭管理
- ✅ 创建家庭
- ✅ 通过邀请码加入家庭
- ✅ 二维码邀请
- ✅ 成员管理
- ✅ 管理员权限

### 3. 日历功能
- ✅ 月视图展示
- ✅ 日期标记
- ✅ 查看当日事项
- ✅ 月份切换

### 4. 事项管理
- ✅ 创建事项
- ✅ 编辑事项
- ✅ 删除事项
- ✅ 事项分类 (7种分类)
- ✅ 事项提醒
- ✅ 重复事项

### 5. 事项响应
- ✅ 同意/拒绝邀请
- ✅ 添加留言
- ✅ 查看响应状态
- ✅ 响应统计

### 6. 通知系统
- ✅ APNs 推送通知
- ✅ 本地通知
- ✅ 通知分类
- ✅ 免打扰模式

### 7. 设置
- ✅ 通知偏好设置
- ✅ 主题设置
- ✅ 数据管理
- ✅ 关于页面

---

## 🛠 技术栈

| 组件 | 技术 |
|------|------|
| UI 框架 | SwiftUI + UIKit |
| 数据存储 | CloudKit |
| 用户认证 | Sign in with Apple |
| 推送通知 | APNs + UNUserNotificationCenter |
| 最低版本 | iOS 16.0+ |
| 开发语言 | Swift 5.9+ |
| 架构模式 | MVVM + Clean Architecture |

---

## 📦 依赖项

本项目使用原生 iOS SDK，无第三方依赖。

---

## 🚀 快速开始

### 1. 环境配置
```bash
cd /Users/armstrong/code/github/FamilyCalendarApp
./setup.sh
```

### 2. 打开项目
```bash
open FamilyCalendar.xcodeproj
```

### 3. 配置 CloudKit
- 在 [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard) 创建容器
- Container ID: `iCloud.com.familycalendar.app`

### 4. 配置 Sign in with Apple
- 在 Apple Developer Portal 启用 Sign in with Apple
- 配置 Entitlements.plist

### 5. 运行
选择模拟器或真机，点击 Run (⌘R)

---

## 📱 界面预览

### 主要界面
1. **登录页** - Sign in with Apple 登录
2. **日历页** - 月视图，显示事项标记
3. **家庭页** - 家庭和成员管理
4. **通知页** - 通知中心
5. **设置页** - 应用设置

### 功能界面
- **创建事项** - 填写标题、时间、地点、分类等
- **事项详情** - 查看详情、参与人、响应邀请
- **邀请家人** - 显示邀请码和二维码

---

## 🔐 权限要求

- `NSUserNotificationsUsageDescription` - 通知权限
- `NSCalendarsUsageDescription` - 日历访问
- `NSCameraUsageDescription` - 相机访问 (头像)
- `NSPhotoLibraryUsageDescription` - 相册访问 (头像)
- `NSCloudKitUsageDescription` - iCloud 使用

---

## 📋 CloudKit 数据模型

### Record Types
- `User` - 用户信息 (Private DB)
- `Family` - 家庭信息 (Shared DB)
- `FamilyMember` - 家庭成员关系 (Shared DB)
- `Event` - 事项 (Shared DB)
- `EventParticipant` - 事项参与 (Shared DB)
- `Comment` - 评论 (Shared DB)
- `Notification` - 通知 (Private DB)

详见 `CLOUDKIT_SCHEMA.md`

---

## 🧪 测试

### 单元测试
```bash
xcodebuild test -scheme FamilyCalendar -destination 'platform=iOS Simulator,name=iPhone 15'
```

### 构建测试
```bash
./build.sh debug
```

---

## 📝 待实现功能

### v1.1 计划
- [ ] 周视图、日视图
- [ ] 事项评论功能
- [ ] 自定义分类标签
- [ ] Widget 小组件

### v1.2 计划
- [ ] 多家庭支持
- [ ] Apple Watch 应用
- [ ] 系统日历导出
- [ ] 事项统计

---

## 🐛 已知问题

1. CloudKit 共享数据库有一些限制
2. 推送通知可能有延迟
3. 多设备同步可能存在短暂延迟

---

## 📖 文档

| 文档 | 说明 |
|------|------|
| README.md | 项目说明和使用指南 |
| DEVELOPMENT.md | 开发指南和最佳实践 |
| CLOUDKIT_SCHEMA.md | CloudKit 数据模型定义 |
| PROJECT_SUMMARY.md | 项目总结 (本文档) |

---

## 🎨 设计规范

### 颜色
- 主色: #FF9500 (橙色)
- 成功: #34C759 (绿色)
- 错误: #FF3B30 (红色)
- 警告: #FFCC00 (黄色)

### 字体
- 使用系统字体 (San Francisco)
- Large Title: 34pt
- Title1: 28pt
- Title2: 22pt
- Body: 17pt
- Caption: 12pt

### 间距
- XS: 4pt
- SM: 8pt
- MD: 16pt
- LG: 24pt
- XL: 32pt

---

## 👥 开发团队

- 开发: FamilyCalendar Team
- 设计: FamilyCalendar Team
- 测试: FamilyCalendar Team

---

## 📄 许可证

版权所有 © 2026 FamilyCalendar

---

## 📞 联系方式

- 网站: https://familycalendar.app
- 邮箱: support@familycalendar.app
- GitHub: https://github.com/familycalendar/app

---

**让家庭沟通更简单** ❤️
