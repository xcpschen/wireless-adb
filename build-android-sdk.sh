#!/bin/bash

# Wireless ADB Switch - 使用自定义 Android SDK Docker 镜像构建

set -e

echo "🔧 Wireless ADB Switch - Android SDK 构建"
echo "========================================"
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    exit 1
fi

# 检查是否在正确的目录
if [ ! -f "build.gradle" ]; then
    echo "❌ 请在项目根目录运行"
    exit 1
fi

# 构建自定义镜像
echo "📦 步骤 1/3: 构建 Android SDK Docker 镜像..."
if docker build -f Dockerfile.android -t wadbs-android .; then
    echo "✅ 镜像构建成功"
else
    echo "❌ 镜像构建失败"
    exit 1
fi

echo ""

# 运行构建
echo "🔨 步骤 2/3: 开始构建项目..."
docker run --rm -v "$(pwd)":/home/gradle/project wadbs-android

echo ""

# 检查构建结果
echo "📋 步骤 3/3: 检查构建结果..."
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    APK_SIZE=$(du -h "app/build/outputs/apk/debug/app-debug.apk" | cut -f1)
    echo ""
    echo "✅ 构建成功!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 APK: app/build/outputs/apk/debug/app-debug.apk"
    echo "📊 大小：$APK_SIZE"
    echo "🎯 支持：Android 7.0+ (API 24-34)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo ""
    echo "❌ 构建失败！"
    exit 1
fi
