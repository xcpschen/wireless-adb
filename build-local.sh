#!/bin/bash

# Wireless ADB Switch - 无网络依赖构建方案
# 适用于无法访问 Docker Hub 的环境

set -e

echo "🔧 Wireless ADB Switch - 本地构建方案"
echo "======================================"
echo ""

# 检查是否安装了 Java
if ! command -v java &> /dev/null; then
    echo "❌ 错误：未检测到 Java 环境"
    echo ""
    echo "💡 请安装 JDK 17："
    echo "   macOS:  brew install openjdk@17"
    echo "   Linux:  sudo apt install openjdk-17-jdk"
    echo "   Windows: 下载 https://adoptium.net/"
    exit 1
fi

# 检查 Java 版本
echo "🔍 检查 Java 环境..."

# 尝试多种方式获取 Java 版本
if java -version 2>&1 | grep -q "java version"; then
    JAVA_VERSION=$(java -version 2>&1 | grep "java version" | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
elif java -version 2>&1 | grep -q "openjdk version"; then
    JAVA_VERSION=$(java -version 2>&1 | grep "openjdk version" | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
else
    # 尝试另一种格式
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | grep -oE '[0-9]+\.' | head -n 1 | cut -d'.' -f1)
fi

# 如果还是无法获取，尝试使用 javac
if [ -z "$JAVA_VERSION" ] || ! [[ "$JAVA_VERSION" =~ ^[0-9]+$ ]]; then
    if command -v javac &> /dev/null; then
        JAVA_VERSION=$(javac -version 2>&1 | head -n 1 | cut -d' ' -f2 | cut -d'.' -f1)
    fi
fi

# 最后的检查
if [ -z "$JAVA_VERSION" ] || ! [[ "$JAVA_VERSION" =~ ^[0-9]+$ ]]; then
    echo "❌ 无法检测到 Java 版本"
    echo ""
    echo "💡 请安装 Java 17 或更高版本："
    echo "   macOS:  brew install openjdk@17"
    echo "   Linux:  sudo apt install openjdk-17-jdk"
    echo "   Windows: 下载 https://adoptium.net/"
    exit 1
fi

echo "✅ 检测到 Java 版本：$JAVA_VERSION"

if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "⚠️  警告：需要 Java 17 或更高版本"
    echo "   当前版本：$JAVA_VERSION"
    echo ""
    echo "💡 请升级 Java："
    echo "   macOS:  brew install openjdk@17"
    echo "   Linux:  sudo apt install openjdk-17-jdk"
    exit 1
fi

# 检查是否安装了 Gradle
if ! command -v gradle &> /dev/null; then
    echo "⚠️  Gradle 未安装，使用 Gradle Wrapper..."
    GRADLE_CMD="./gradlew"
    
    # 检查 gradlew 是否存在
    if [ ! -f "./gradlew" ]; then
        echo "❌ 错误：gradlew 不存在"
        exit 1
    fi
    
    # 给 gradlew 添加执行权限
    chmod +x ./gradlew
else
    GRADLE_CMD="gradle"
    echo "✅ 使用系统 Gradle"
fi

echo ""
echo "🔨 开始构建..."
echo ""

# 运行构建
$GRADLE_CMD clean assembleDebug --no-daemon

echo ""

# 检查构建结果
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    APK_SIZE=$(du -h "app/build/outputs/apk/debug/app-debug.apk" | cut -f1)
    echo ""
    echo "✅ 构建成功!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 APK 文件：app/build/outputs/apk/debug/app-debug.apk"
    echo "📊 文件大小：$APK_SIZE"
    echo "🎯 支持版本：Android 7.0+ (API 24-34)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # 显示文件路径
    echo ""
    echo "📁 完整路径："
    echo "   $(pwd)/app/build/outputs/apk/debug/app-debug.apk"
    echo ""
    
    # macOS 用户可以直接打开
    if [[ "$OSTYPE" == "darwin"* ]]; then
        read -p "是否打开 APK 所在文件夹？(y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            open "$(pwd)/app/build/outputs/apk/debug/"
        fi
    fi
else
    echo ""
    echo "❌ 构建失败！"
    echo "请检查上面的错误信息"
    exit 1
fi
