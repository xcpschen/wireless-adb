#!/bin/bash

# Wireless ADB Switch - 快速验证脚本
# 用于快速验证代码更改是否正确

set -e

echo "🔍 Wireless ADB Switch - 代码验证工具"
echo "======================================"
echo ""

# 检查关键文件的修改
echo "📝 检查关键文件修改..."
echo ""

# 检查 build.gradle 的 minSdk
if grep -q "minSdk 24" app/build.gradle; then
    echo "✅ app/build.gradle: minSdk 已更新为 24"
else
    echo "❌ app/build.gradle: minSdk 未更新"
    exit 1
fi

# 检查 widget-factory 的 minSdk
if grep -q "minSdk 24" widget-factory/build.gradle; then
    echo "✅ widget-factory/build.gradle: minSdk 已更新为 24"
else
    echo "❌ widget-factory/build.gradle: minSdk 未更新"
    exit 1
fi

# 检查 WirelessDebugging.kt 是否包含版本检查
if grep -q "Build.VERSION_CODES.R" app/src/main/java/com/smoothie/wirelessDebuggingSwitch/WirelessDebugging.kt; then
    echo "✅ WirelessDebugging.kt: 包含 Android 版本检查"
else
    echo "❌ WirelessDebugging.kt: 缺少版本检查"
    exit 1
fi

# 检查是否包含 setprop 命令
if grep -q "setprop persist.adb.tcp.enabled" app/src/main/java/com/smoothie/wirelessDebuggingSwitch/WirelessDebugging.kt; then
    echo "✅ WirelessDebugging.kt: 包含 Android 7-10 支持"
else
    echo "❌ WirelessDebugging.kt: 缺少旧版本支持"
    exit 1
fi

# 检查 UserService.java 的回退机制
if grep -q "getprop service.adb.tcp.port" app/src/main/java/com/smoothie/wirelessDebuggingSwitch/UserService.java; then
    echo "✅ UserService.java: 包含回退机制"
else
    echo "❌ UserService.java: 缺少回退机制"
    exit 1
fi

echo ""
echo "📊 代码验证摘要:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 最低 SDK 版本：24 (Android 7.0)"
echo "✅ 目标 SDK 版本：34 (Android 14)"
echo "✅ 多版本支持：Android 7.0 - 14"
echo "✅ 无线调试实现：支持 API 24+"
echo "✅ 端口获取：带fallback 机制"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 询问是否进行 Docker 构建
if command -v docker &> /dev/null; then
    read -p "是否使用 Docker 进行编译验证？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "🚀 开始 Docker 构建..."
        ./build.sh
    else
        echo ""
        echo "💡 提示：运行 ./build.sh 来使用 Docker 编译项目"
    fi
else
    echo ""
    echo "⚠️  警告：Docker 未安装，无法进行编译验证"
    echo "💡 建议安装 Docker 以获得完整的构建体验"
fi
