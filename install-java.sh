#!/bin/bash

# 自动安装 Java 17 脚本（适用于 macOS）

set -e

echo "🔧 Java 17 自动安装脚本"
echo "======================"
echo ""

# 检测操作系统
if [[ ! "$OSTYPE" == "darwin"* ]]; then
    echo "⚠️  此脚本仅适用于 macOS"
    echo "Linux 用户请使用：sudo apt install openjdk-17-jdk"
    exit 1
fi

# 检查是否已安装 Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew 未安装"
    echo ""
    echo "💡 请先安装 Homebrew："
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

echo "✅ Homebrew 已安装"
echo ""

# 检查是否已安装 Java 17
if java -version 2>&1 | grep -q "version \"17"; then
    echo "✅ Java 17 已安装"
    java -version
    exit 0
fi

echo "📦 开始安装 Java 17..."
echo ""

# 使用 Homebrew 安装 OpenJDK 17
brew update
brew install openjdk@17

echo ""
echo "✅ Java 17 安装完成！"
echo ""

# 显示安装信息
echo "📍 Java 安装位置："
ls -la /opt/homebrew/opt/openjdk@17/bin/java 2>/dev/null || ls -la /usr/local/opt/openjdk@17/bin/java 2>/dev/null || echo "   位置未知"

echo ""
echo "🔧 配置 JAVA_HOME（可选）："
echo "   将以下内容添加到 ~/.zshrc 或 ~/.bash_profile："
echo ""
echo '   export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"'
echo '   export JAVA_HOME="/opt/homebrew/opt/openjdk@17"'
echo ""

# 询问是否自动配置
read -p "是否自动配置 JAVA_HOME？(y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 检测 shell
    SHELL_NAME=$(basename $SHELL)
    
    if [[ "$SHELL_NAME" == "zsh" ]]; then
        PROFILE_FILE="$HOME/.zshrc"
    else
        PROFILE_FILE="$HOME/.bash_profile"
    fi
    
    # 备份现有配置
    if [ -f "$PROFILE_FILE" ]; then
        cp "$PROFILE_FILE" "$PROFILE_FILE.bak"
    fi
    
    # 添加配置
    cat >> "$PROFILE_FILE" << 'EOF'

# Java 17 configuration
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
EOF
    
    echo "✅ 配置已添加到 $PROFILE_FILE"
    echo ""
    echo "🔄 使配置生效："
    echo "   source $PROFILE_FILE"
    
    # 询问是否立即生效
    read -p "是否现在使配置生效？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        source "$PROFILE_FILE"
        echo "✅ 配置已生效"
    fi
fi

echo ""
echo "🧪 验证安装："
echo "   java -version"
echo ""

# 询问是否验证
read -p "是否现在验证？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    java -version
fi

echo ""
echo "🎉 完成！你现在可以运行 ./build-local.sh 进行构建了"
