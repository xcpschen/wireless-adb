#!/bin/bash

# 提交代码并重建 tag
# 用法：./commit-and-rebuild-tag.sh <tag版本> <commit信息> <tag信息>

set -e

# 检查参数
if [ $# -lt 3 ]; then
    echo "❌ 用法：$0 <tag版本> <commit信息> <tag信息>"
    echo ""
    echo "示例："
    echo "  $0 v1.3.1 \"Update: 重构项目支持 Android 7+\" \"Release version 1.3.1\""
    exit 1
fi

TAG_VERSION=$1
COMMIT_MESSAGE=$2
TAG_MESSAGE=$3

echo "🔄 提交代码并重建 tag $TAG_VERSION"
echo "=================================="
echo ""

# 1. 检查当前分支
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "📍 当前分支：$BRANCH"
echo ""

# 2. 添加所有更改
echo "📝 添加所有更改..."
git add .
echo "✅ 已添加所有更改"
echo ""

# 3. 提交更改
echo "💾 提交更改..."
git commit -m "$COMMIT_MESSAGE"
echo "✅ 已提交更改"
echo ""

# 4. 推送到远程
echo "🚀 推送到远程仓库..."
git push origin $BRANCH
echo "✅ 代码已推送到远程"
echo ""

# 5. 删除本地 tag
echo "🗑️  删除本地 tag $TAG_VERSION..."
if git tag -l | grep -q "$TAG_VERSION"; then
    git tag -d $TAG_VERSION
    echo "✅ 已删除本地 tag $TAG_VERSION"
else
    echo "ℹ️  本地 tag $TAG_VERSION 不存在"
fi
echo ""

# 6. 删除远程 tag
echo "🗑️  删除远程 tag $TAG_VERSION..."
if git ls-remote --tags origin | grep -q "$TAG_VERSION"; then
    git push origin :refs/tags/$TAG_VERSION
    echo "✅ 已删除远程 tag $TAG_VERSION"
else
    echo "ℹ️  远程 tag $TAG_VERSION 不存在"
fi
echo ""

# 7. 创建新 tag
echo "🏷️  创建新 tag $TAG_VERSION..."
git tag -a $TAG_VERSION -m "$TAG_MESSAGE"
echo "✅ 已创建新 tag $TAG_VERSION"
echo ""

# 8. 推送新 tag
echo "🚀 推送新 tag 到远程..."
git push origin $TAG_VERSION
echo "✅ 已推送 tag $TAG_VERSION 到远程"
echo ""

# 9. 验证
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
echo "✅ 代码已提交并推送：$COMMIT_MESSAGE"
echo "✅ Tag $TAG_VERSION 已重建并推送"
echo ""
echo "🔗 查看 GitHub Actions:"
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -n "$REMOTE_URL" ]; then
    REPO_NAME=$(echo $REMOTE_URL | sed 's/.*github.com[:/]/' | sed 's/\.git$//')
    echo "   https://github.com/$REPO_NAME/actions"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
