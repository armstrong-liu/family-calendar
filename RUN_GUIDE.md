# 📱 如何查看App效果 - 快速指南

## 方法一：使用 Xcode 模拟器（推荐）

### 步骤 1: 打开 Xcode 项目
```bash
cd /Users/armstrong/code/github/FamilyCalendarApp
open FamilyCalendar.xcodeproj
```

### 步骤 2: 配置项目
在 Xcode 中：
1. **选择开发团队**
   - 点击项目导航器中的 "FamilyCalendar" 项目（蓝色图标）
   - 选择 TARGETS → FamilyCalendar
   - 点击 "Signing & Capabilities"
   - 在 "Team" 下拉菜单中选择你的 Apple ID
   - 如果没有，点击 "Add Account..." 添加

2. **选择模拟器**
   - 点击工具栏上的设备选择器（通常显示 "FamilyCalendar > ")
   - 选择一个模拟器，推荐：
     - iPhone 15
     - iPhone 15 Pro
     - iPhone SE (较小屏幕)

### 步骤 3: 运行项目
- 点击左上角的 ▶️ (Run) 按钮
- 或按快捷键 `⌘ + R`

### 步骤 4: 查看效果
模拟器启动后，你会看到：
1. **登录页面** - Sign in with Apple 按钮
2. **日历主页** - 月视图日历
3. **家庭管理** - 创建/加入家庭
4. **通知中心** - 通知列表
5. **设置页面** - 应用设置

---

## 方法二：使用命令行构建

### 构建项目
```bash
cd /Users/armstrong/code/github/FamilyCalendarApp
xcodebuild -scheme FamilyCalendar -destination 'platform=iOS Simulator,name=iPhone 15'
```

---

## 🎯 快速功能测试流程

### 1. 测试登录
- 点击 "Sign in with Apple"
- 模拟 Apple ID 登录

### 2. 创建家庭
- 点击 "家庭" 标签
- 点击 "创建家庭"
- 输入家庭名称，如"幸福一家人"

### 3. 创建事项
- 点击 "日历" 标签
- 点击右上角 ➕ 按钮
- 填写事项信息：
  - 标题：周末聚餐
  - 时间：选择日期和时间
  - 分类：选择"聚餐"
  - 点击"保存"

### 4. 查看事项
- 在日历上查看事项标记
- 点击事项查看详情
- 测试"同意/拒绝"功能

### 5. 测试通知
- 进入"设置"标签
- 开启通知权限
- 创建带提醒的事项

---

## ⚠️ 注意事项

### CloudKit 配置（可选，用于真实数据同步）
如果要启用 CloudKit 数据同步：

1. **访问 CloudKit Dashboard**
   ```
   https://icloud.developer.apple.com/dashboard
   ```

2. **创建容器**
   - Container ID: `iCloud.com.familycalendar.app`
   - 或者在 `CloudKitManager.swift` 中修改为你的容器ID

3. **更新代码**
   ```swift
   // 在 CloudKitManager.swift 中
   self.container = CKContainer(identifier: "你的容器ID")
   ```

### Sign in with Apple（需要真机测试）
- Sign in with Apple 在模拟器中可能不完全可用
- 建议使用真机测试完整功能

### 推送通知（需要真机测试）
- APNs 推送通知需要真机
- 模拟器中只能看到本地通知

---

## 🔧 常见问题

### Q: Xcode 报错 "No such module"？
A: 清理项目并重新构建：
```bash
⌘ + Shift + K  (Clean Build Folder)
⌘ + R         (Run)
```

### Q: 编译失败，提示代码错误？
A: 检查 Swift 版本，确保使用 Swift 5.0+

### Q: Sign in with Apple 不工作？
A: 需要在真机上测试，模拟器支持有限

### Q: 如何查看真实效果？
A: 使用真机测试：
1. 连接 iPhone 到 Mac
2. 在 Xcode 中选择你的设备
3. 点击 Run

---

## 📸 功能预览

### 登录页
- Sign in with Apple 按钮
- 功能介绍图标

### 日历页
- 月视图日历
- 事项标记（橙色圆点）
- 点击日期查看事项
- 创建事项按钮（➕）

### 事项详情
- 事项标题和分类
- 时间和地点
- 参与人员列表
- 同意/拒绝按钮

### 家庭管理
- 家庭信息卡片
- 成员列表
- 邀请码分享

### 通知中心
- 通知列表
- 已读/未读标记
- 通知分类图标

### 设置页
- 用户信息
- 通知设置
- 免打扰模式
- 退出登录

---

## 🎨 UI 特点

- **橙色主题** - 温馨的家庭氛围
- **圆角设计** - 现代简洁
- **图标丰富** - 使用 SF Symbols
- **动画流畅** - SwiftUI 原生动画

---

## 📞 需要帮助？

查看详细文档：
- `README.md` - 项目说明
- `DEVELOPMENT.md` - 开发指南
- `CLOUDKIT_SCHEMA.md` - 数据模型

---

**祝您使用愉快！** 🎉
