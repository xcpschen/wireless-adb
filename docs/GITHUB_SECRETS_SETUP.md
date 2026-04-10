# 🔐 配置 GitHub Secrets 指南

## 📋 需要添加的 Secrets

访问：`https://github.com/你的用户名/wireless-adb-switch/settings/secrets/actions`

添加以下 **4 个 Secrets**：

---

### 1. KEYSTORE ⭐

**名称**：`KEYSTORE`

**值**：查看文件 `keystore.base64.txt` 的内容

**获取方法**：
```bash
cd /Users/chan/code/wireless-adb
cat keystore.base64.txt
```

**复制整个输出**（一长串字符），粘贴到 GitHub Secrets。

---

### 2. KEYSTORE_PASSWORD

**名称**：`KEYSTORE_PASSWORD`

**值**：`wireless-adb-123`

---

### 3. KEY_PASSWORD

**名称**：`KEY_PASSWORD`

**值**：`wireless-adb-123`

---

### 4. KEY_ALIAS

**名称**：`KEY_ALIAS`

**值**：`wireless-adb`

---

## 🚀 操作步骤

### 步骤 1: 打开 GitHub Secrets

1. 访问：`https://github.com/你的用户名/wireless-adb-switch/settings/secrets/actions`
2. 点击 "New repository secret"

### 步骤 2: 添加 KEYSTORE

```
Name: KEYSTORE
Value: [粘贴 keystore.base64.txt 的完整内容]
```

### 步骤 3: 添加密码

```
Name: KEYSTORE_PASSWORD
Value: wireless-adb-123
```

```
Name: KEY_PASSWORD
Value: wireless-adb-123
```

### 步骤 4: 添加别名

```
Name: KEY_ALIAS
Value: wireless-adb
```

---

## ✅ 验证配置

### 查看已添加的 Secrets

在 `https://github.com/你的用户名/wireless-adb-switch/settings/secrets/actions` 应该看到：

| Name | Last updated |
|------|--------------|
| KEYSTORE | 刚刚 |
| KEYSTORE_PASSWORD | 刚刚 |
| KEY_PASSWORD | 刚刚 |
| KEY_ALIAS | 刚刚 |

---

## 🎯 测试 GitHub Actions 构建

### 1. 推送 Tag

```bash
git tag -a v1.3 -m "Release version 1.3"
git push origin v1.3
```

### 2. 查看构建

访问：`https://github.com/你的用户名/wireless-adb-switch/actions`

应该看到构建自动开始，并生成：
- ✅ `wireless-adb-debug` (Debug APK)
- ✅ `wireless-adb-release` (Release APK，已签名)

### 3. 下载 APK

1. 点击最新的构建
2. 在 "Artifacts" 部分下载
   - `wireless-adb-debug.zip`
   - `wireless-adb-release.zip`
3. 解压得到 APK 文件

---

## 💡 常见问题

### Q: base64 内容太长怎么办？

**A**: 直接复制整个文件内容，GitHub 支持长 Secret。

### Q: 需要换行吗？

**A**: 不需要，`keystore.base64.txt` 已经是单行格式。

### Q: 可以修改密码吗？

**A**: 可以，但需要：
1. 重新生成密钥库
2. 更新 `keystore.properties`
3. 更新 GitHub Secrets

### Q: 忘记添加某个 Secret 怎么办？

**A**: 随时可以添加或修改，不需要删除已有的。

---

## 🔒 安全提示

### 本地文件保护

```bash
# 这些文件已添加到 .gitignore，不会提交：
- wireless-adb.keystore       # 密钥库
- keystore.properties         # 配置文件
- keystore.base64.txt         # base64 编码

# 建议备份到安全位置
cp wireless-adb.keystore /path/to/secure/location/
cp keystore.properties /path/to/secure/location/
```

### GitHub Secrets 安全

- ✅ 加密存储
- ✅ 只在构建时访问
- ✅ 不会在日志中显示
- ✅ 只有仓库管理员可以查看

---

## 📊 完整配置清单

- [x] ✅ 生成密钥库
- [x] ✅ 创建配置文件
- [x] ✅ 更新 build.gradle
- [x] ✅ 生成 base64 编码
- [ ] ⏳ 添加 GitHub Secrets（手动操作）
- [ ] ⏳ 测试 GitHub Actions 构建

---

## 🎊 完成后

配置完 GitHub Secrets 后：

1. **推送 tag 自动构建**
   ```bash
   git tag -a v1.3 -m "Release v1.3"
   git push origin v1.3
   ```

2. **下载签名的 APK**
   - 在 GitHub Actions 页面
   - 下载 `wireless-adb-release.zip`

3. **直接安装**
   ```bash
   adb install wireless-adb-1.3.apk
   ```

---

**下一步**：访问 GitHub 添加 Secrets！🚀
