# 🔧 GitHub Actions Base64 解码问题修复

## ❌ 问题原因

```
base64: invalid input
```

**原因**：macOS 的 `base64` 命令生成的格式与 Linux 的 `base64 --decode` 不兼容。

---

## ✅ 解决方案

### 方案 1：使用 OpenSSL（已采用）⭐

在 GitHub Actions 中使用 `openssl` 命令：

```yaml
- name: Decode Keystore
  if: ${{ secrets.KEYSTORE != '' && secrets.KEYSTORE != null }}
  run: |
    echo "${{ secrets.KEYSTORE }}" | openssl base64 -d -out wireless-adb.keystore
  shell: bash
```

**优点**：
- ✅ OpenSSL 在 Linux 和 macOS 上都可用
- ✅ 解码更可靠
- ✅ 支持各种 base64 格式

---

### 方案 2：重新生成正确的 base64 编码

如果你想在本地重新生成适合 Linux 的 base64 编码：

#### 在 Linux 环境下（推荐）

```bash
# 使用 GitHub Actions 环境或 Linux 虚拟机
base64 -w 0 wireless-adb.keystore > keystore.base64.linux.txt
```

#### 使用 Docker

```bash
# 使用 Ubuntu 容器生成
docker run --rm -v $(pwd):/work -w /work ubuntu:latest \
  bash -c "apt-get update && apt-get install -y base64 && base64 -w 0 wireless-adb.keystore"
```

#### 使用在线工具

1. 上传 `wireless-adb.keystore` 到在线 base64 编码器
2. 复制输出（确保是单行，无换行）
3. 添加到 GitHub Secrets

---

## 🚀 更新后的 Workflow

### 修改内容

**之前**（使用 base64 命令）：
```yaml
- name: Decode Keystore
  run: |
    echo "${{ secrets.KEYSTORE }}" | base64 --decode > wireless-adb.keystore
```

**现在**（使用 OpenSSL）：
```yaml
- name: Decode Keystore
  run: |
    echo "${{ secrets.KEYSTORE }}" | openssl base64 -d -out wireless-adb.keystore
```

---

## 📝 重新添加 Secret（如果需要）

如果使用 OpenSSL 后仍有问题，可能需要重新生成 base64 编码：

### 步骤 1：在 GitHub Actions 中测试

创建一个测试 workflow：

```yaml
name: Test Base64

on: [workflow_dispatch]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Test Decode
        run: |
          echo "${{ secrets.KEYSTORE }}" | openssl base64 -d -out test.keystore
          ls -lh test.keystore
          keytool -list -v -keystore test.keystore -storepass wireless-adb-123
```

### 步骤 2：验证输出

应该看到密钥库信息。如果失败，重新生成 base64。

---

## 💡 macOS vs Linux Base64 对比

| 系统 | 命令 | 参数 | 输出 |
|------|------|------|------|
| **macOS** | `base64` | `-i input -o output -b 0` | 单行 |
| **Linux** | `base64` | `-w 0 input -o output` | 单行 |
| **OpenSSL** | `openssl base64` | `-e 编码 -d 解码` | 跨平台 |

---

## ✅ 验证清单

- [x] ✅ Workflow 已更新为使用 OpenSSL
- [x] ✅ 条件判断已修复
- [ ] ⏳ 测试 GitHub Actions 构建
- [ ] ⏳ 验证密钥库解码成功

---

## 🎯 下一步

### 推送测试

```bash
# 推送 tag 触发构建
git push origin v1.3.1 --force
```

### 查看结果

访问：`https://github.com/xcpschen/wireless-adb-switch/actions`

应该看到：
1. ✅ Decode Keystore 步骤成功
2. ✅ 创建密钥库文件
3. ✅ 构建继续进行

---

## 🔍 故障排查

### 如果仍然失败

#### 检查 Secret 内容

```bash
# 在 GitHub Secrets 页面检查 KEYSTORE
# 应该是连续的 base64 字符串，无换行，无空格
```

#### 测试解码

在 GitHub Actions 中添加调试步骤：

```yaml
- name: Debug Keystore
  run: |
    echo "Keystore length: ${#KEYSTORE}"
    echo "First 100 chars: ${KEYSTORE:0:100}"
  env:
    KEYSTORE: ${{ secrets.KEYSTORE }}
```

#### 重新生成 Secret

如果内容有问题，重新生成：

```bash
# 在 Linux 环境或使用 Docker
docker run --rm -v $(pwd):/work -w /work ubuntu:latest \
  bash -c "apt-get update && apt-get install -y base64 && base64 -w 0 /work/wireless-adb.keystore"
```

复制输出到 GitHub Secrets。

---

## 🎊 完成！

现在使用 OpenSSL 解码，应该能在 GitHub Actions 中正常工作！

**推送 tag 测试**：
```bash
git push origin v1.3.1 --force
```

然后查看 GitHub Actions 结果！🚀
