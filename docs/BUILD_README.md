# Wireless ADB Switch - 构建说明

## 🚀 快速开始

### 方式一：使用 Docker（推荐）

```bash
# 使用官方镜像构建
./build-fast.sh
```

**APK 输出位置**：
```
app/build/outputs/apk/debug/app-debug.apk
```

### 方式二：本地构建

需要环境：
- Java 17+
- Android SDK
- Gradle 8.7+

```bash
./build-local.sh
```

---

## 📦 Docker 构建

### 使用官方镜像

```bash
./build-fast.sh
```

这个脚本会：
1. 从 Docker Hub 拉取 `gradle:8.7-jdk17` 镜像
2. 挂载当前目录到容器
3. 运行 Gradle 构建
4. 生成 APK 到本地目录

### 使用自定义镜像

如果需要完整的 Android SDK 环境：

```bash
# 构建自定义镜像
docker build -t wadbs-build .

# 运行构建
docker run --rm -v $(pwd):/app wadbs-build gradle clean build
```

---

## 🎯 项目信息

**支持版本**：Android 7.0+ (API 24-34)

**主要功能**：
- ✅ 无线调试开关
- ✅ Quick Settings Tile
- ✅ 桌面小部件
- ✅ Root/Shizuku 支持
- ✅ 开机自启

---

## 📝 构建输出

- **Debug APK**: `app/build/outputs/apk/debug/app-debug.apk`
- **Release APK**: `app/build/outputs/apk/release/app-release-unsigned.apk`

---

## ⚙️ 环境要求

### Docker 方式
- Docker Desktop
- 网络连接（访问 Docker Hub）

### 本地方式
- JDK 17+
- Android SDK (API 34)
- Gradle 8.7+

---

## 🔧 故障排除

### Docker 网络问题

如果无法拉取镜像，请检查：
1. Docker 是否正常运行
2. 网络连接是否正常
3. 代理配置是否正确

### 本地构建问题

确保环境变量正确设置：
```bash
export JAVA_HOME=/path/to/java17
export ANDROID_HOME=/path/to/android-sdk
export PATH=$PATH:$JAVA_HOME/bin:$ANDROID_HOME/platform-tools
```

---

**更多信息请查看 [REFACTOR_SUMMARY.md](REFACTOR_SUMMARY.md)**
