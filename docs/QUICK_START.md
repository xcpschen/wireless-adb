# 🚀 快速开始 - Wireless ADB Switch

## 📦 项目重构完成

✅ **支持版本**: Android 7.0 - 14 (API 24-34)  
✅ **构建方式**: Docker / 本地 Gradle  
✅ **所有功能**: 完整保留

---

## ⚡ 30 秒快速开始

### 步骤 1: 验证代码修改
```bash
./verify.sh
```

### 步骤 2: 选择构建方式

**方式 A - 本地构建（推荐，无需 Docker）**：
```bash
# 需要 Java 17+
./build-local.sh
```

**方式 B - Docker 构建**：
```bash
# 如果遇到网络问题，先配置镜像加速器
./configure-docker-mirror.sh
./build-fast.sh
```

### 步骤 3: 获取 APK
```
app/build/outputs/apk/debug/app-debug.apk
```

---

## 🎯 常用命令

### Docker 构建
```bash
# 快速构建（推荐）
./build-fast.sh

# 使用自定义镜像
docker build -t android-wadbs .
docker run --rm -v $(pwd):/app android-wadbs gradle clean build

# 构建 Release 版本
docker run --rm -v $(pwd):/app android-wadbs gradle assembleRelease
```

### 本地构建
```bash
# 需要 JDK 17 + Android SDK
./gradlew clean build
```

### 验证和测试
```bash
# 验证代码修改
./verify.sh

# 查看项目任务
docker run --rm -v $(pwd):/app gradle:8.7-jdk17 gradle tasks
```

---

## 📁 重要文件

### 构建脚本
- `build-fast.sh` - ⚡ 快速构建（使用预构建镜像）
- `build.sh` - 🐳 自定义镜像构建
- `verify.sh` - ✅ 代码验证

### 文档
- `REFACTOR_SUMMARY.md` - 📋 重构总结（**推荐先看这个**）
- `DOCKER_README.md` - 🐳 Docker 快速入门
- `DOCKER_BUILD.md` - 🔧 Docker 构建详细指南
- `DOCKER.md` - 🛠️ 构建环境配置

### 核心代码
- `app/src/main/java/.../WirelessDebugging.kt` - 多版本无线调试实现
- `app/src/main/java/.../UserService.java` - 端口获取回退机制
- `app/build.gradle` - SDK 版本配置

---

## 🔍 验证清单

运行 `./verify.sh` 检查：

- ✅ minSdk 版本：24 (Android 7.0)
- ✅ 目标版本：34 (Android 14)
- ✅ Android 版本检查代码
- ✅ 无线调试多版本支持
- ✅ 端口获取回退机制

---

## 📊 构建时间

| 构建方式 | 首次时间 | 后续时间 |
|---------|---------|---------|
| Docker (预构建) | 2-3 分钟 | 1-2 分钟 |
| Docker (自定义) | 5-10 分钟 | 1-2 分钟 |
| 本地构建 | 3-5 分钟 | 30-60 秒 |

---

## 🛠️ 故障排除

### Docker 网络问题
```bash
# 使用国内镜像源
docker build --build-arg USE_MIRROR=true -t android-wadbs .
```

### 权限问题
```bash
# 修复文件权限
sudo chown -R $(id -u):$(id -g) app/build/
```

### 内存不足
编辑 `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx2048m
```

---

## 📱 测试建议

在以下版本测试：
- ✅ Android 7.0-7.1 (API 24-25)
- ✅ Android 8.0-8.1 (API 26-27)
- ✅ Android 9.0 (API 28)
- ✅ Android 10 (API 29)
- ✅ Android 11+ (API 30+)

测试场景：
- 启用/禁用无线调试
- Root 模式
- Shizuku 模式
- 小部件功能
- Quick Settings Tile

---

## 📚 更多信息

- [完整重构总结](REFACTOR_SUMMARY.md)
- [Docker 构建指南](DOCKER_BUILD.md)
- [项目原始文档](readme.md)

---

**提示**: 首次使用 Docker 会下载镜像，请耐心等待。后续构建会使用缓存，速度更快。
