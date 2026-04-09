#!/bin/bash

# Wireless ADB Switch - 使用官方 Docker 镜像进行快速构建
# 直接使用 Docker Hub 官方镜像

set -e

echo "🔧 Wireless ADB Switch - 快速构建（官方镜像）"
echo "=========================================="
echo ""

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ 错误：Docker 未安装！"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查是否在正确的目录
if [ ! -f "build.gradle" ]; then
    echo "❌ 错误：请在项目根目录运行此脚本"
    exit 1
fi

echo "📦 使用官方 Gradle 镜像..."
echo ""

# 直接使用官方镜像
GRADLE_IMAGE="gradle:8.7-jdk17"

echo "🔍 检查本地镜像..."

# 检查本地是否有镜像
if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "^gradle:8.7-jdk17$"; then
    echo "✓ 本地已有 $GRADLE_IMAGE 镜像"
else
    echo "⏳ 从 Docker Hub 拉取 $GRADLE_IMAGE ..."
    docker pull "$GRADLE_IMAGE"
    echo "✓ 镜像拉取完成"
fi

echo ""
echo "🔨 开始构建..."
echo ""

# 运行构建
docker run --rm \
    -v "$(pwd)":/home/gradle/project \
    -w /home/gradle/project \
    "$GRADLE_IMAGE" \
    gradle clean assembleDebug --no-daemon

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
else
    echo ""
    echo "❌ 构建失败！"
    echo "请检查上面的错误信息"
    exit 1
fi
