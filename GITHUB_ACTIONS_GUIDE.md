# GitHub Actions 配置指南

## 📋 前置条件

- GitHub 账号（免费）
- 代码已在本地目录

---

## 🚀 配置步骤

### 步骤 1: 在 GitHub 创建新仓库

1. 访问 https://github.com/new
2. 填写仓库信息：
   - **Repository name**: `family-calendar` (或任意名称)
   - **Description**: `家庭日历 iOS App`
   - **Visibility**: ✅ Public（免费使用 Actions）或 Private（也可用）
3. ❌ **不要**勾选 "Add a README file"
4. 点击 **Create repository**

### 步骤 2: 推送代码到 GitHub

```bash
# 进入项目目录
cd /Users/armstrong/code/github/FamilyCalendarApp

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Family Calendar iOS App"

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/family-calendar.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

**重要**：将 `YOUR_USERNAME` 替换为您的 GitHub 用户名

### 步骤 3: 触发 GitHub Actions 构建

推送完成后，GitHub Actions 会自动开始构建。

#### 自动触发
- 当您推送代码到 `main` 或 `develop` 分支时
- 创建 Pull Request 时

#### 手动触发
1. 访问您的 GitHub 仓库
2. 点击 **Actions** 标签
3. 选择 **"Build and Release iOS App"** workflow
4. 点击右侧 **"Run workflow"** 按钮
5. 选择分支（默认 `main`）
6. 点击 **"Run workflow"** 绿色按钮

### 步骤 4: 监控构建进度

1. 在 GitHub 仓库，点击 **Actions** 标签
2. 你会看到正在运行的工作流（黄色圆点 ●）
3. 点击进入可以查看详细日志
4. 等待大约 **5-10 分钟**

### 步骤 5: 下载 IPA 文件

构建成功后（绿色 ✓）：

1. 在 Actions 页面，点击成功的 workflow run
2. 滚动到底部 **"Artifacts"** 部分
3. 你会看到：
   - `FamilyCalendar-1.ipa` ← 点击这个
   - `Build-Info-1.ipa`
4. 点击下载，解压得到 **FamilyCalendar.ipa**

---

## 📱 安装 IPA 到 iPhone

### 方法 1: AltStore（推荐，免费）

#### 在 iPhone 上：
1. 打开 Safari 访问：https://altstore.io/
2. 点击 **"Download AltStore"**
3. 在设置中信任开发者证书
   - 设置 → 通用 → VPN与设备管理 → 信任

#### 在 Mac 上：
1. 访问：https://altstore.io/
2. 下载并安装 **AltServer**
3. 打开 AltServer（菜单栏会出现图标）

#### 安装 IPA：
1. 用数据线连接 iPhone 到 Mac
2. 确保 iPhone 已解锁并信任电脑
3. 在 Mac 上双击下载的 **FamilyCalendar.ipa**
4. AltServer 会自动安装到 iPhone
5. 输入 Apple ID 和密码（用于签名）

**⚠️ 注意**：
- 免费账号签名的 App 7 天后需要重新签名
- AltStore 会在后台自动刷新（如果连接电脑）

### 方法 2: Sideloadly（跨平台）

#### 下载安装：
1. 访问：https://sideloadly.io/
2. 下载对应系统的版本（macOS/Windows/Linux）
3. 安装并打开 Sideloadly

#### 安装 IPA：
1. 用数据线连接 iPhone 到电脑
2. 打开 Sideloadly
3. 确保 iPhone 已解锁
4. 将 **FamilyCalendar.ipa** 拖拽到 Sideloadly 窗口
5. 输入 Apple ID 和密码
6. 等待安装完成

### 方法 3: Cydia Impactor（不推荐）

⚠️ **注意**：此工具已停止更新，在新版 macOS 上可能无法运行

---

## 🔧 常见问题

### Q: 构建失败怎么办？
**A**: 检查 Actions 日志，常见原因：
- Xcode 项目配置问题
- 文件路径错误
- GitHub Actions 运行器问题

查看日志：
```
Actions → 选择失败的 run → 展开失败的步骤
```

### Q: IPA 文件无法安装？
**A**: 确认：
1. IPA 文件完整（重新下载）
2. iPhone 已信任开发者证书
3. iOS 版本兼容（iOS 16.0+）

### Q: 提示"需要开发者账号"？
**A**:
- 免费方案：使用 AltStore 或 Sideloadly（7天有效期）
- 付费方案：加入 Apple Developer Program ($99/年)

### Q: 如何修改代码重新构建？
**A**:
```bash
# 修改代码后
git add .
git commit -m "描述你的修改"
git push

# GitHub Actions 会自动开始新构建
```

### Q: 构建需要多长时间？
**A**:
- 首次构建：约 10-15 分钟
- 后续构建：约 5-8 分钟

---

## 📊 构建配置说明

当前配置 (`ios-build.yml`) 会：

1. ✅ 使用 Xcode 14.2
2. ✅ 构建 Debug 版本
3. ✅ 不需要代码签名（开发用途）
4. ✅ 生成 .ipa 文件
5. ✅ 保留 30 天
6. ✅ 支持手动和自动触发

---

## 🎯 快速命令参考

```bash
# 查看构建状态
git log --oneline -5

# 查看远程仓库
git remote -v

# 强制推送（谨慎使用）
git push --force

# 创建新分支
git checkout -b feature/new-feature
git push -u origin feature/new-feature

# 查看所有分支
git branch -a
```

---

## 📝 推送模板

### 首次推送
```bash
cd /Users/armstrong/code/github/FamilyCalendarApp
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/family-calendar.git
git push -u origin main
```

### 后续更新
```bash
git add .
git commit -m "feat: 添加新功能"
git push
```

---

## 🎉 完成后

一旦构建成功并下载 IPA：

1. ✅ 在 iPhone 安装 AltStore
2. ✅ 用 AltStore 打开 IPA 文件
3. ✅ App 安装到 iPhone
4. ✅ 开始使用 Family Calendar！

---

## 📞 获取帮助

- GitHub Actions 状态：https://github.com/YOUR_USERNAME/family-calendar/actions
- 查看构建日志
- 检查 `DEVELOPMENT.md` 了解开发细节

---

**准备好了吗？开始推送代码吧！** 🚀
