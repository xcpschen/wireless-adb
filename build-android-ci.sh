#!/bin/bash

# 使用官方 Android CI 镜像构建

set -e

echo "🔧 Wireless ADB Switch - 使用 Android CI 镜像"
echo "==========================================="
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装"
    exit 1
fi

echo "📦 步骤 1/3: 拉取 Android CI 镜像..."
docker pull androidsdk/android-34

echo ""
echo "🔨 步骤 2/3: 开始构建..."
docker run --rm \
    -v "$(pwd)":/home/project \
    -w /home/project \
    androidsdk/android-34 \
    gradle clean assembleDebug --no-daemon

echo ""
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
