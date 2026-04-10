#!/bin/bash

# 验证签名配置并测试构建

set -e

echo "🔐 验证签名配置"
echo "==============="
echo ""

# 检查密钥库
if [ ! -f "wireless-adb.keystore" ]; then
    echo "❌ 密钥库文件不存在"
    exit 1
fi
echo "✅ 密钥库文件存在：wireless-adb.keystore"

# 检查 keystore.properties
if [ ! -f "keystore.properties" ]; then
    echo "❌ keystore.properties 不存在"
    exit 1
fi
echo "✅ 配置文件存在：keystore.properties"

# 验证密钥库
echo ""
echo "🔍 验证密钥库信息..."
/opt/homebrew/opt/openjdk@17/bin/keytool -list -v -keystore wireless-adb.keystore -storepass wireless-adb-123 | head -20

echo ""
echo "🔨 构建签名的 Release APK..."
echo ""

# 构建
./gradlew clean assembleRelease

echo ""

# 检查输出
if [ -f "app/build/outputs/apk/release/wireless-adb-1.3.apk" ]; then
    APK_PATH="app/build/outputs/apk/release/wireless-adb-1.3.apk"
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    
    echo "✅ 构建成功!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 APK: wireless-adb-1.3.apk"
    echo "📊 大小：$APK_SIZE"
    echo "🔐 已签名：是"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # 验证签名
    echo ""
    echo "🔍 验证 APK 签名..."
    /opt/homebrew/opt/openjdk@17/bin/jarsigner -verify -verbose -certs "$APK_PATH" | grep -E "s by|证书"
    
    echo ""
    echo "✅ APK 已正确签名，可以安装！"
else
    echo "❌ 构建失败"
    exit 1
fi
