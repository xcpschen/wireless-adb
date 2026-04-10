#!/bin/bash

# 提交代码并重建 tag，或只重建 tag
# 用法：
#   ./commit-and-rebuild-tag.sh <tag 版本> <commit 信息> <tag 信息>  # 提交并重建 tag
#   ./commit-and-rebuild-tag.sh <tag 版本> --no-commit              # 只重建 tag

set -e

# 检查参数
if [ $# -lt 2 ]; then
    echo "❌ 用法：$0 <tag 版本> <commit信息> <tag 信息>"
    echo ""
    echo "或只重建 tag（不提交代码）："
    echo "   $0 <tag 版本> --no-commit"
    echo ""
    echo "示例："
    echo "  提交并重建："
    echo "    $0 v1.3.1 \"Update: 重构项目\" \"Release v1.3.1\""
    echo ""
    echo "  只重建 tag："
    echo "    $0 v1.3.1 --no-commit"
    exit 1
fi

TAG_VERSION=$1

# 检查是否是只重建 tag 模式
if [ "$2" = "--no-commit" ]; then
    NO_COMMIT=true
    TAG_MESSAGE=$3
else
    NO_COMMIT=false
    COMMIT_MESSAGE=$2
    TAG_MESSAGE=$3
fi

echo "🔄 重建 tag $TAG_VERSION"
echo "=================================="
echo ""

# 1. 检查当前分支
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📍 当前分支：$BRANCH"
echo ""

# 2. 提交代码（如果不是 --no-commit 模式）
if [ "$NO_COMMIT" = false ]; then
    # 添加所有更改
    echo "📝 添加所有更改..."
    git add .
    echo "✅ 已添加所有更改"
    echo ""
    
    # 提交更改
    echo "💾 提交更改..."
    git commit -m "$COMMIT_MESSAGE"
    echo "✅ 已提交更改"
    echo ""
    
    # 推送到远程
    echo "🚀 推送到远程仓库..."
    git push origin $BRANCH
    echo "✅ 代码已推送到远程"
    echo ""
else
    echo "⏭️  跳过代码提交（--no-commit 模式）"
    echo ""
fi

# 3. 删除本地 tag（如果存在）
echo "🗑️  删除本地 tag $TAG_VERSION..."
if git tag -l | grep -q "$TAG_VERSION"; then
    git tag -d $TAG_VERSION
    echo "✅ 已删除本地 tag $TAG_VERSION"
else
    echo "ℹ️  本地 tag $TAG_VERSION 不存在，跳过删除"
fi
echo ""

# 4. 删除远程 tag（如果存在）
echo "🗑️  删除远程 tag $TAG_VERSION..."
if git ls-remote --tags origin | grep -q "$TAG_VERSION"; then
    git push origin :refs/tags/$TAG_VERSION
    echo "✅ 已删除远程 tag $TAG_VERSION"
else
    echo "ℹ️  远程 tag $TAG_VERSION 不存在，跳过删除"
fi
echo ""

# 5. 创建新 tag
echo "🏷️  创建新 tag $TAG_VERSION..."
if [ -n "$TAG_MESSAGE" ]; then
    git tag -a $TAG_VERSION -m "$TAG_MESSAGE"
else
    git tag -a $TAG_VERSION -m "Release $TAG_VERSION"
fi
echo "✅ 已创建新 tag $TAG_VERSION"
echo ""

# 6. 推送新 tag
echo "🚀 推送新 tag 到远程..."
git push origin $TAG_VERSION
echo "✅ 已推送 tag $TAG_VERSION 到远程"
echo ""

# 7. 验证
echo "✅ 验证..."
echo ""
echo "📋 本地 tags:"
git tag | grep "$TAG_VERSION" || echo "   (无)"
echo ""

echo "📋 远程 tags:"
git ls-remote --tags origin | grep "$TAG_VERSION" | cut -f2 || echo "   (无)"
echo ""

echo "🎉 完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$NO_COMMIT" = false ]; then
    echo "✅ 代码已提交并推送：$COMMIT_MESSAGE"
fi
echo "✅ Tag $TAG_VERSION 已重建并推送"
echo ""
echo "🔗 查看 GitHub Actions:"
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -n "$REMOTE_URL" ]; then
    REPO_NAME=$(echo $REMOTE_URL | sed 's/.*github.com[:/]/' | sed 's/\.git$//')
    echo "   https://github.com/$REPO_NAME/actions"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
