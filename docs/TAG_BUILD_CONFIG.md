# 🏷️ GitHub Actions Tag 触发配置

## ✅ 配置完成

已修改 GitHub Actions 配置，现在**只在推送 tag 时**才会触发构建。

---

## 📋 触发条件

### 会触发构建的 tag
```bash
v1.3
v1.4
v2.0
1.3
1.4
2.0
```

### 不会触发构建的操作
- ❌ Push 到分支（main/master）
- ❌ Pull Request
- ❌ 普通的代码提交

---

## 🚀 使用方法

### 方式 1：使用 Git 命令

```bash
# 1. 更新版本号（在 app/build.gradle 中）
# 修改 versionName "1.3"

# 2. 提交更改
git add .
git commit -m "Release version 1.3"

# 3. 创建并推送 tag
git tag v1.3
git push origin v1.3
```

### 方式 2：使用 GitHub UI

1. 访问：`https://github.com/用户名/wireless-adb-switch/releases/new`
2. 点击 "Choose a tag" → "Create new tag"
3. 输入 tag 名称（如 `v1.3`）
4. 填写发布说明
5. 点击 "Publish release"

---

## 📊 Tag 命名规则

### 支持的格式

| Tag 格式 | 示例 | 说明 |
|---------|------|------|
| `v` + 版本号 | `v1.3` | 推荐格式 ✅ |
| 纯版本号 | `1.3` | 也支持 |
| 带补丁版本 | `v1.3.1` | 支持 |
| 预发布版本 | `v1.3-beta` | 支持 |

### 推荐格式

```bash
v主版本号。次版本号。修订号
# 例如：
v1.3.0
v1.3.1
v2.0.0
```

---

## 🎯 完整发布流程

### 1. 更新版本号

编辑 `app/build.gradle`：

```gradle
defaultConfig {
    versionCode 5              // 递增整数
    versionName "1.4"          // 新版本号
}
```

### 2. 提交代码

```bash
git add .
git commit -m "Bump version to 1.4"
```

### 3. 创建并推送 tag

```bash
git tag v1.4
git push origin v1.4
```

### 4. GitHub Actions 自动构建

推送 tag 后，GitHub Actions 会自动：
1. ✅ 检出代码
2. ✅ 设置 JDK 17
3. ✅ 构建 Debug APK
4. ✅ 构建 Release APK
5. ✅ 上传 Artifact

### 5. 下载 APK

1. 访问：`https://github.com/用户名/wireless-adb-switch/actions`
2. 点击最近的构建（对应你的 tag）
3. 下载 Artifact：
   - `wireless-adb-debug` → `wireless-adb-1.4.apk`
   - `wireless-adb-release` → `wireless-adb-1.4.apk`

---

## 📝 示例命令

### 发布新版本

```bash
# 1. 更新版本号
# 编辑 app/build.gradle

# 2. 提交
git add app/build.gradle
git commit -m "Release v1.4"

# 3. 推送到远程
git push origin main

# 4. 创建并推送 tag
git tag v1.4
git push origin v1.4
```

### 查看现有 tags

```bash
# 本地 tags
git tag

# 远程 tags
git ls-remote --tags origin
```

### 删除 tag（如果需要）

```bash
# 删除本地 tag
git tag -d v1.3

# 删除远程 tag
git push origin :refs/tags/v1.3
```

---

## 🔍 验证配置

### 检查 workflow 文件

```bash
cat .github/workflows/build.yml
```

应该看到：

```yaml
on:
  push:
    tags:
      - 'v*'
      - '*'
```

### 测试配置

```bash
# 创建测试 tag
git tag v999.999
git push origin v999.999

# 然后在 GitHub Actions 页面查看是否触发构建

# 删除测试 tag
git tag -d v999.999
git push origin :refs/tags/v999.999
```

---

## 💡 高级用法

### 只匹配特定格式的 tag

如果只想匹配 `v` 开头的 tag：

```yaml
on:
  push:
    tags:
      - 'v*'
```

### 排除预发布版本

```yaml
on:
  push:
    tags:
      - 'v*'
      - '!*-*'  # 排除包含 '-' 的 tag（如 v1.0-beta）
```

### 同时支持分支和 tag

```yaml
on:
  push:
    branches:
      - main
    tags:
      - 'v*'
```

---

## 📊 对比

| 触发条件 | 旧配置 | 新配置 |
|---------|--------|--------|
| Push 到分支 | ✅ 触发 | ❌ 不触发 |
| Pull Request | ✅ 触发 | ❌ 不触发 |
| Push tag | ✅ 触发 | ✅ 触发 |
| 日常提交 | ✅ 触发 | ❌ 不触发 |

---

## ✅ 总结

- ✅ **只在推送 tag 时构建**
- ✅ **支持 `v*` 和纯数字 tag**
- ✅ **节省 GitHub Actions 运行次数**
- ✅ **适合正式发布流程**

**配置完成！** 🎉 现在只有打 tag 才会触发自动构建！
