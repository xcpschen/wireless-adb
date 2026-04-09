#!/bin/bash

# Wireless ADB Switch - Docker 构建脚本
# 此脚本会自动构建 Docker 镜像并编译项目

set -e

echo "🔧 Wireless ADB Switch - Docker 构建工具"
echo "========================================"
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

# 检查 Dockerfile 是否存在
if [ ! -f "Dockerfile" ]; then
    echo "❌ 错误：Dockerfile 不存在"
    exit 1
fi

# 构建 Docker 镜像
echo "📦 步骤 1/3: 构建 Docker 镜像..."
if docker images android-build -q | grep -q .; then
    echo "✓ Docker 镜像已存在，跳过构建"
else
    docker build -t android-build .
    echo "✓ Docker 镜像构建完成"
fi
echo ""

# 运行 Gradle 构建
echo "🔨 步骤 2/3: 编译项目..."
docker run --rm -v "$(pwd)":/app android-build gradle clean assembleDebug

echo ""

# 检查构建结果
echo "📋 步骤 3/3: 检查构建结果..."
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    APK_SIZE=$(du -h "app/build/outputs/apk/debug/app-debug.apk" | cut -f1)
    echo ""
    echo "✅ 构建成功!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 APK 文件：app/build/outputs/apk/debug/app-debug.apk"
    echo "📊 文件大小：$APK_SIZE"
    echo "🎯 支持版本：Android 7.0+ (API 24-34)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # 询问是否打开文件位置
    if command -v open &> /dev/null; then
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
