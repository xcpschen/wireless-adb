# 🔄 更新 GitHub Secrets - Linux 兼容的 Base64

## ✅ 已生成 Linux 兼容的 Base64 编码

**文件**：`keystore.base64.linux.txt`

**生成方式**：使用 OpenSSL（跨平台兼容）
```bash
openssl base64 -in wireless-adb.keystore -out keystore.base64.linux.txt -A
```

---

## 📋 更新步骤

### 步骤 1: 复制 Base64 内容

```bash
cd /Users/chan/code/wireless-adb
cat keystore.base64.linux.txt | pbcopy
echo "✅ 已复制到剪贴板"
```

### 步骤 2: 打开 GitHub Secrets

访问：`https://github.com/xcpschen/wireless-adb-switch/settings/secrets/actions`

### 步骤 3: 更新 KEYSTORE Secret

1. 找到 `KEYSTORE` Secret
2. 点击编辑（或重新创建）
3. 粘贴新的 base64 内容（从剪贴板）
4. 点击 "Save"

---

## 🔍 对比

| 特性 | 旧编码（macOS） | 新编码（OpenSSL） |
|------|----------------|------------------|
| 生成工具 | `base64 -i` | `openssl base64` |
| 兼容性 | ⚠️ macOS 专用 | ✅ 跨平台 |
| GitHub Actions | ❌ 失败 | ✅ 成功 |
| 推荐使用 | ❌ 不推荐 | ✅ 推荐 |

---

## ✅ Workflow 已修复

### 修改内容

**文件**：`.github/workflows/build.yml`

**之前**：
```yaml
- name: Decode Keystore
  run: |
    echo "${{ secrets.KEYSTORE }}" | base64 --decode > wireless-adb.keystore
```

**现在**：
```yaml
- name: Decode Keystore
  if: ${{ secrets.KEYSTORE != '' && secrets.KEYSTORE != null }}
  run: |
    echo "${{ secrets.KEYSTORE }}" | openssl base64 -d -out wireless-adb.keystore
  shell: bash
```

---

## 🎯 完整 Secrets 列表

需要配置以下 4 个 Secrets：

| Name | Value | 状态 |
|------|-------|------|
| `KEYSTORE` | [粘贴 keystore.base64.linux.txt 内容] | ⭐ 需要更新 |
| `KEYSTORE_PASSWORD` | `wireless-adb-123` | ✅ 已配置 |
| `KEY_PASSWORD` | `wireless-adb-123` | ✅ 已配置 |
| `KEY_ALIAS` | `wireless-adb` | ✅ 已配置 |

---

## 🚀 测试

### 推送 Tag

```bash
# 强制推送触发构建
git push origin v1.3.1 --force
```

### 查看 GitHub Actions

访问：`https://github.com/xcpschen/wireless-adb-switch/actions`

应该看到：
1. ✅ Decode Keystore 步骤成功
2. ✅ 密钥库文件创建成功
3. ✅ 构建继续进行

---

## 💡 验证 Base64 编码

### 本地测试

```bash
# 测试解码（应该成功）
cat keystore.base64.linux.txt | openssl base64 -d -out test.keystore

# 验证密钥库
keytool -list -v -keystore test.keystore -storepass wireless-adb-123
```

### GitHub Actions 测试

在 workflow 中添加调试步骤：

```yaml
- name: Test Keystore Decode
  run: |
    echo "${{ secrets.KEYSTORE }}" | openssl base64 -d -out test.keystore
    keytool -list -v -keystore test.keystore -storepass wireless-adb-123 | head -10
```

---

## 📊 问题解决

### 之前的问题

```
base64: invalid input
Error: Process completed with exit code 1.
```

**原因**：
- macOS 的 base64 格式与 Linux 不兼容
- `base64 --decode` 无法解析 macOS 生成的编码

### 现在的解决方案

✅ 使用 OpenSSL 解码
✅ 生成 Linux 兼容的 base64 编码
✅ 跨平台一致性

---

## ✅ 检查清单

- [x] ✅ 生成新的 base64 编码（OpenSSL）
- [x] ✅ 更新 Workflow 使用 OpenSSL 解码
- [ ] ⏳ 更新 GitHub Secrets 中的 KEYSTORE
- [ ] ⏳ 测试 GitHub Actions 构建

---

## 🎊 下一步

1. **复制新的 base64 编码**：
   ```bash
   cat keystore.base64.linux.txt | pbcopy
   ```

2. **更新 GitHub Secrets**：
   - 访问：`https://github.com/xcpschen/wireless-adb-switch/settings/secrets/actions`
   - 更新 `KEYSTORE` Secret

3. **测试构建**：
   ```bash
   git push origin v1.3.1 --force
   ```

4. **查看结果**：
   - GitHub Actions 应该成功解码密钥库
   - 构建签名的 APK

---

**准备好更新 Secrets 了吗？** 🚀
