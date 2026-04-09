#!/bin/bash

# 修复并配置 Java 17 环境

echo "🔧 配置 Java 17 环境"
echo "=================="
echo ""

# Java 17 路径
JAVA_17_PATH="/opt/homebrew/opt/openjdk@17"

# 检查 Java 17 是否已安装
if [ ! -d "$JAVA_17_PATH" ]; then
    echo "❌ Java 17 未安装"
    echo "请先运行：./install-java.sh"
    exit 1
fi

echo "✅ Java 17 已安装在：$JAVA_17_PATH"
echo ""

# 临时设置当前会话
export PATH="$JAVA_17_PATH/bin:$PATH"
export JAVA_HOME="$JAVA_17_PATH"

echo "📍 当前会话已配置"
echo ""

# 检查 .zshrc 是否已包含 Java 17 配置
if grep -q "openjdk@17" ~/.zshrc 2>/dev/null; then
    echo "✅ .zshrc 已包含 Java 17 配置"
else
    echo "📝 添加 Java 17 配置到 ~/.zshrc..."
    
    # 创建备份
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
    
    # 在文件末尾添加配置
    cat >> ~/.zshrc << 'EOF'

# Java 17 configuration (added by install-java.sh)
if [ -d "/opt/homebrew/opt/openjdk@17" ]; then
    export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
    export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
fi
EOF
    
    echo "✅ 配置已添加到 ~/.zshrc"
    echo "💡 备份文件：~/.zshrc.backup.*"
fi

echo ""
echo "🧪 验证配置..."
echo ""

# 重新加载配置（使用更安全的方式）
# 不直接 source，而是启动新的 shell
echo "✅ 配置完成！"
echo ""
echo "📋 下一步："
echo "   1. 关闭当前终端并重新打开"
echo "   2. 或者运行：exec zsh"
echo "   3. 然后验证：java -version"
echo ""
echo "🚀 或者现在就可以运行构建："
echo "   ./build-local.sh"
echo ""

# 询问是否验证
read -p "是否现在验证 Java 版本？(y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 在当前 shell 中验证
    if [ -d "$JAVA_17_PATH/bin" ]; then
        "$JAVA_17_PATH/bin/java" -version
    else
        echo "⚠️  无法找到 Java 可执行文件"
    fi
fi

echo ""
echo "🎉 完成！"
