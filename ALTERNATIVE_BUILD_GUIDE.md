# 无需本地 Xcode 构建 iOS App 指南

## 当前限制
- macOS 11.3 无法通过 App Store 安装 Xcode
- 需要其他方式构建 iOS App

---

## 方案对比

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| 1. 下载 Xcode DMG | 完整开发环境 | 文件大 (~12GB) | ⭐⭐⭐⭐⭐ |
| 2. GitHub Actions | 免费，自动化 | 需要 Git 推送 | ⭐⭐⭐⭐ |
| 3. 第三方CI/CD | 快速 | 需要配置 | ⭐⭐⭐ |
| 4. 升级 macOS | 一劳永逸 | 可能需要新硬件 | ⭐⭐⭐⭐⭐ |

---

## 方案一：下载 Xcode DMG（最直接）

### 步骤 1: 获取 Xcode

**选项 A：Apple Developer 网站**
```
1. 访问：https://developer.apple.com/download/all/
2. 登录 Apple ID（免费注册）
3. 搜索 "Xcode 14.2" 或 "Xcode 13.4.1"
4. 下载 .xip 文件（约 12GB）
```

**选项 B：直接下载链接**
```bash
# Xcode 14.2 (支持 macOS 11.3+)
# 需要登录 Apple Developer 账号后使用

# 使用 aria2 加速下载（如果已安装）
aria2c -x 16 -s 16 [Xcode下载链接]
```

### 步骤 2: 解压和安装
```bash
# 解压 .xip 文件
xip -x Xcode_14.2.xip

# 移动到应用程序文件夹
sudo mv Xcode.app /Applications/

# 安装命令行工具
xcode-select --install
```

### 步骤 3: 同意许可并初始化
```bash
# 同意 Xcode 许可
sudo xcodebuild -license accept

# 设置开发者目录
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

---

## 方案二：使用 GitHub Actions（推荐，无需本地 Xcode）

### 步骤 1: 推送代码到 GitHub

```bash
# 1. 在 GitHub 创建新仓库
# 例如：github.com/yourusername/family-calendar

# 2. 初始化 Git 仓库
cd /Users/armstrong/code/github/FamilyCalendarApp
git init
git add .
git commit -m "Initial commit: Family Calendar App"

# 3. 推送到 GitHub
git remote add origin https://github.com/yourusername/family-calendar.git
git branch -M main
git push -u origin main
```

### 步骤 2: 配置 GitHub Actions

已在 `.github/workflows/build.yml` 创建配置文件

### 步骤 3: 触发构建

**方式 1：推送代码触发**
```bash
git add .
git commit -m "Trigger build"
git push
```

**方式 2：手动触发**
1. 访问 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择 "Build iOS App" workflow
4. 点击 "Run workflow" → "Run workflow"

### 步骤 4: 下载 IPA 文件

1. 等待构建完成（约 5-10 分钟）
2. 进入 "Actions" → 最近的 workflow run
3. 滚动到 "Artifacts" 部分
4. 下载 "FamilyCalendar-iOS" 文件
5. 解压得到 `FamilyCalendar.ipa`

### 步骤 5: 安装到 iPhone

**方法 A：使用 AltStore（推荐）**
```
1. 在 iPhone 安装 AltStore (https://altstore.io/)
2. 用数据线连接 iPhone 到 Mac
3. 在 Mac 上打开 AltStore
4. 双击 .ipa 文件安装
```

**方法 B：使用 Sideloadly**
```
1. 下载 Sideloadly (https://sideloadly.io/)
2. 连接 iPhone
3. 拖拽 .ipa 文件到 Sideloadly
4. 输入 Apple ID 进行签名
```

**方法 C：使用 Cydia Impactor（旧版）**
```
注意：此工具已停止更新，可能不兼容最新系统
```

---

## 方案三：使用第三方 CI/CD 服务

### 选项 1: Bitrise
```
1. 访问 https://www.bitrise.io/
2. 注册账号（免费套餐可用）
3. 连接 GitHub 仓库
4. 选择工作流模板
5. 开始构建
```

### 选项 2: AppCenter
```
1. 访问 https://appcenter.ms/
2. 使用 Microsoft 账号登录
3. 创建新应用
4. 连接代码仓库
5. 配置构建
```

---

## 方案四：升级 macOS（长期推荐）

如果可能，考虑升级到：
- macOS 12 (Monterey)
- macOS 13 (Ventura)
- macOS 14 (Sonoma)

**好处**：
- 可以通过 App Store 直接安装最新 Xcode
- 更好的开发体验
- 更完整的系统支持

---

## 快速决策指南

### 如果你只想快速看效果：
→ **使用 GitHub Actions**（方案二）
- 优点：无需本地安装，免费
- 缺点：每次构建需要 5-10 分钟

### 如果要经常开发：
→ **下载 Xcode DMG**（方案一）
- 优点：完整开发体验，即时构建
- 缺点：下载大 (~12GB)，需要空间

### 如果有升级计划：
→ **升级 macOS + 安装 Xcode**
- 优点：最佳体验，长期方案
- 缺点：可能需要硬件升级

---

## 签名和安装说明

### 免费开发者签名
- 有效期：7 天
- 需要：Apple ID（免费）
- 工具：AltStore, Sideloadly

### 付费开发者签名
- 有效期：1 年
- 需要：Apple Developer Program ($99/年)
- 好处：可以发布到 App Store，TestFlight

---

## 推荐流程

### 最快路径（今天就能看效果）：

```
1. 推送代码到 GitHub
   ↓
2. 在 GitHub Actions 手动触发构建
   ↓
3. 等待 5-10 分钟
   ↓
4. 下载 .ipa 文件
   ↓
5. 在 iPhone 安装 AltStore
   ↓
6. 用 AltStore 安装 .ipa
   ↓
7. 🎉 开始使用！
```

---

## 常见问题

### Q: GitHub Actions 构建需要付费吗？
A: 公开仓库完全免费，私有仓库也有免费额度

### Q: .ipa 文件可以直接安装吗？
A: 需要签名。免费签名 7 天有效期，或使用付费开发者账号

### Q: 能否绕过签名直接安装？
A: 不能，iOS 系统要求所有 App 都必须签名

### Q: AltStore 安全吗？
A: 安全，它是开源的，使用官方 API 进行签名

---

## 需要帮助？

查看详细构建文档：
- `RUN_GUIDE.md` - 运行指南
- `DEVELOPMENT.md` - 开发指南
- `.github/workflows/build.yml` - GitHub Actions 配置

---

**选择最适合您的方案，立即开始！** 🚀
