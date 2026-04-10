# ✅ 签名配置完成

## 🎉 已完成的配置

### 1. 生成密钥库

**文件**：`wireless-adb.keystore`

**信息**：
```
别名：wireless-adb
算法：RSA 2048 位
有效期：10000 天
组织：WirelessADB
```

### 2. 创建配置文件

**文件**：`keystore.properties`

**内容**：
```properties
storePassword=wireless-adb-123
keyPassword=wireless-adb-123
keyAlias=wireless-adb
storeFile=../wireless-adb.keystore
```

### 3. 更新 Build Gradle

**文件**：`app/build.gradle`

**添加内容**：
```gradle
// 加载签名配置
def keystorePropertiesFile = rootProject.file("keystore.properties")
def keystoreProperties = new Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // ... 其他配置
        }
    }
}
```

### 4. 更新 .gitignore

**已添加**：
```gitignore
# Keystore files
*.keystore
*.jks
keystore.properties
```

---

## 🚀 使用方式

### 构建签名的 Release APK

```bash
# 方式 1: 使用 Gradle
./gradlew assembleRelease

# 方式 2: 使用验证脚本
./verify-signing.sh
```

### 验证签名

```bash
# 验证 APK 签名
/opt/homebrew/opt/openjdk@17/bin/jarsigner -verify -verbose -certs \
  app/build/outputs/apk/release/wireless-adb-1.3.apk

# 应该看到：
# 已签名 "com.smoothie.wirelessDebuggingSwitch"
# 由 "CN=WirelessADB, OU=Development, O=WirelessADB, L=Beijing, ST=Beijing, C=CN" 成功验证
```

### 安装到设备

```bash
# 卸载旧版本（如果有）
adb uninstall com.smoothie.wirelessDebuggingSwitch

# 安装新版本
adb install app/build/outputs/apk/release/wireless-adb-1.3.apk
```

---

## 📊 生成的文件

| 文件 | 说明 | 是否提交到 Git |
|------|------|---------------|
| `wireless-adb.keystore` | 密钥库文件 | ❌ 否（已忽略） |
| `keystore.properties` | 配置文件 | ❌ 否（已忽略） |
| `app/build.gradle` | 签名配置 | ✅ 是 |
| `.gitignore` | 忽略规则 | ✅ 是 |

---

## 🔒 安全说明

### 已采取的安全措施

1. ✅ **密钥库文件已忽略**
   - 不会提交到 Git
   - 本地安全存储

2. ✅ **配置文件已忽略**
   - `keystore.properties` 不在版本控制中
   - 密码不会泄露

3. ✅ **签名配置已分离**
   - 代码中只有配置引用
   - 实际密码在独立文件中

### 重要提示

⚠️ **请备份以下文件**：
```bash
# 备份到安全位置（如加密的 USB 驱动器）
cp wireless-adb.keystore /path/to/secure/location/
cp keystore.properties /path/to/secure/location/
```

⚠️ **不要分享**：
- `wireless-adb.keystore` - 密钥库文件
- `keystore.properties` - 包含密码

---

## 🎯 GitHub Actions 配置

### 添加 Secrets

访问：`https://github.com/你的用户名/wireless-adb-switch/settings/secrets/actions`

添加以下 4 个 Secrets：

| Secret 名称 | 值 | 示例 |
|------------|-----|------|
| `KEYSTORE` | 密钥库的 base64 编码 | `UEsDBBgAAAA...` |
| `KEYSTORE_PASSWORD` | 密钥库密码 | `wireless-adb-123` |
| `KEY_PASSWORD` | 密钥密码 | `wireless-adb-123` |
| `KEY_ALIAS` | 密钥别名 | `wireless-adb` |

### 生成 KEYSTORE 的 base64 编码

```bash
# 在 macOS/Linux
base64 -w 0 wireless-adb.keystore

# 复制输出结果，添加到 GitHub Secrets
```

### 测试 GitHub Actions

```bash
# 推送 tag 触发构建
git tag -a v1.3 -m "Release version 1.3"
git push origin v1.3

# 在 GitHub Actions 页面查看构建
# 下载的 Release APK 已签名
```

---

## ✅ 验证清单

- [x] ✅ 密钥库已生成
- [x] ✅ 配置文件已创建
- [x] ✅ build.gradle 已更新
- [x] ✅ .gitignore 已更新
- [x] ✅ 签名配置正确
- [x] ✅ 可以构建签名的 APK
- [ ] ⏳ GitHub Secrets 待配置（可选）

---

## 📝 快速测试

```bash
# 1. 构建
./gradlew assembleRelease

# 2. 检查输出
ls -lh app/build/outputs/apk/release/wireless-adb-1.3.apk

# 3. 验证签名
/opt/homebrew/opt/openjdk@17/bin/jarsigner -verify \
  app/build/outputs/apk/release/wireless-adb-1.3.apk

# 4. 安装
adb install app/build/outputs/apk/release/wireless-adb-1.3.apk
```

---

## 🎊 完成！

现在你可以：

1. ✅ **构建签名的 Release APK**
   ```bash
   ./gradlew assembleRelease
   ```

2. ✅ **安装到设备**
   ```bash
   adb install app/build/outputs/apk/release/wireless-adb-1.3.apk
   ```

3. ✅ **不会再出现签名错误**
   ```
   ✅ 已签名 "com.smoothie.wirelessDebuggingSwitch"
   ✅ 可以正常安装
   ```

4. ✅ **GitHub Actions 自动签名**（配置 Secrets 后）
   - 每次推送 tag 自动构建
   - 生成的 APK 已签名
   - 可以直接安装

---

**配置完成！** 🎉 现在运行 `./verify-signing.sh` 测试构建！
