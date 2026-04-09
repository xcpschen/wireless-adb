# 🐳 Docker 构建最终方案

## ✅ 可以用 Docker 编译！

但是需要使用**正确的镜像**。由于项目使用了 AIDL（Shizuku 支持），需要完整的 Android SDK 环境。

---

## 🎯 推荐方案：使用 GitHub Actions

这是**最简单可靠**的方式：

### 创建 `.github/workflows/build.yml`：

```yaml
name: Build APK

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up JDK 17
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Setup Gradle
        uses: gradle/gradle-build-action@v3
      
      - name: Build with Gradle
        run: ./gradlew assembleDebug
      
      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: app-debug
          path: app/build/outputs/apk/debug/app-debug.apk
```

**优点**：
- ✅ 官方支持，100% 可靠
- ✅ 自动处理所有依赖
- ✅ 免费（公开仓库）
- ✅ 每次提交自动构建

---

## 🛠️ 本地 Docker 方案（如果坚持要用）

### 方案 A：使用 Android Studio 官方镜像

```bash
# 使用 Google 官方的 Android 开发镜像
docker run --rm -it \
    -v "$(pwd)":/home/project \
    -w /home/project \
    us.gcr.io/android-dev-emulator/sdk:latest \
    gradle assembleDebug
```

**注意**：这个镜像很大（~10GB），首次拉取需要时间。

### 方案 B：使用预配置镜像

创建一个完整的 Dockerfile：

```dockerfile
# 基于 Ubuntu
FROM ubuntu:22.04

# 安装基础工具
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/34.0.0

# 安装 Android SDK
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    cd /tmp && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip && \
    mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest

# 接受许可证并安装组件
RUN yes | sdkmanager --licenses >/dev/null 2>&1 && \
    sdkmanager "platform-tools" \
    sdkmanager "platforms;android-34" \
    sdkmanager "build-tools;34.0.0"

# 安装 Gradle
RUN wget https://services.gradle.org/distributions/gradle-8.7-bin.zip -O /tmp/gradle.zip && \
    unzip /tmp/gradle.zip -d /opt && \
    ln -s /opt/gradle-8.7/bin/gradle /usr/local/bin/gradle

WORKDIR /project

CMD ["gradle", "assembleDebug"]
```

**构建和使用**：
```bash
# 构建镜像
docker build -t wadbs-builder .

# 运行构建
docker run --rm -v "$(pwd)":/project wadbs-builder
```

---

## 📊 方案对比

| 方案 | 难度 | 可靠性 | 推荐度 |
|------|------|--------|--------|
| GitHub Actions | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 官方 Android 镜像 | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| 自定义 Dockerfile | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 本地 Android Studio | ⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 🚀 立即开始

### 最简单：GitHub Actions

1. 创建 `.github/workflows/build.yml`（见上方代码）
2. Push 到 GitHub
3. 在 Actions 页面查看构建进度
4. 下载生成的 APK

### 本地：使用 Android Studio

1. 打开 Android Studio
2. File → Open → 选择项目
3. Build → Build APK

---

## 💡 为什么 Docker 构建复杂？

**原因**：项目使用了 AIDL（Android Interface Definition Language）

AIDL 需要：
- ✅ 完整的 C++ 运行时库
- ✅ 正确版本的 glibc
- ✅ Android SDK build-tools 完整安装

这些在精简 Docker 镜像中很难配置正确。

---

## ✅ 结论

**可以用 Docker 编译**，但：
- 推荐使用 **GitHub Actions**（最可靠）
- 或者使用 **本地 Android Studio**
- 如果坚持用 Docker，需要配置完整的 Android SDK 环境

**项目代码重构已完成**，支持 Android 7.0+！🎉
