#!/bin/bash

# macOS 专用：生成密钥库的 base64 编码

echo "🔐 生成密钥库 base64 编码（macOS）"
echo "=================================="
echo ""

if [ ! -f "wireless-adb.keystore" ]; then
    echo "❌ 错误：找不到 wireless-adb.keystore"
    exit 1
fi

# 生成 base64 编码
echo "📝 生成 base64 编码..."
base64 -i wireless-adb.keystore -o keystore.base64.txt -b 0

echo "✅ 已生成：keystore.base64.txt"
echo ""
echo "📋 使用方法："
echo ""
echo "方式 1: 查看并复制"
echo "   cat keystore.base64.txt"
echo ""
echo "方式 2: 直接复制到剪贴板（需要 xclip 或 pbcopy）"
if command -v pbcopy &> /dev/null; then
    echo "   cat keystore.base64.txt | pbcopy"
    echo "   # 已复制到剪贴板，可以直接粘贴"
    cat keystore.base64.txt | pbcopy
    echo ""
fi

echo ""
echo "🎯 添加到 GitHub Secrets："
echo "   1. 访问：https://github.com/你的用户名/wireless-adb-switch/settings/secrets/actions"
echo "   2. 添加 Secret: KEYSTORE"
echo "   3. 粘贴上面的内容"
echo ""

# 显示前 100 个字符
echo "📄 文件前 100 字符："
head -c 100 keystore.base64.txt
echo "..."
echo ""
echo "💡 完整内容：cat keystore.base64.txt"
