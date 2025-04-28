#!/bin/bash

# 一键提交到 GitHub 的脚本

# 检查是否在 Git 仓库中
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "错误：当前目录不是 Git 仓库！请先初始化 Git 仓库（git init）或切换到正确的目录。"
    exit 1
fi

# 检查 Git 配置
if [ -z "$(git config user.name)" ] || [ -z "$(git config user.email)" ]; then
    echo "错误：Git 用户名或邮箱未配置！请先设置："
    echo "  git config --global user.name 'yuuniji'"
    echo "  git config --global user.email 'yuuniji81@gmail.com'"
    exit 1
fi

# 检查 Git 用户名是否匹配
CURRENT_NAME=$(git config user.name)
if [ "$CURRENT_NAME" != "yuuniji" ]; then
    echo "警告：当前 Git 用户名 ($CURRENT_NAME) 与提供的用户名 (yuuniji) 不匹配。"
    echo "正在更新为提供的用户名..."
    git config --global user.name "yuuniji"
fi

# 检查 Git 邮箱是否匹配
CURRENT_EMAIL=$(git config user.email)
if [ "$CURRENT_EMAIL" != "yuuniji81@gmail.com" ]; then
    echo "警告：当前 Git 邮箱 ($CURRENT_EMAIL) 与提供的邮箱 (yuuniji81@gmail.com) 不匹配。"
    echo "正在更新为提供的邮箱..."
    git config --global user.email "yuuniji81@gmail.com"
fi

# 检查是否有远程仓库
if [ -z "$(git remote -v)" ]; then
    echo "错误：未设置远程仓库！请先添加远程仓库，例如："
    echo "  git remote add origin https://github.com/yuuniji/about.git"
    exit 1
fi

# 获取提交信息
if [ -z "$1" ]; then
    COMMIT_MSG="自动提交于 $(date '+%Y-%m-%d %H:%M:%S')"
else
    COMMIT_MSG="$1"
fi

# 添加所有更改
echo "添加所有更改..."
git add .

# 检查是否有更改需要提交
if git diff --staged --quiet; then
    echo "没有更改需要提交。"
    exit 0
fi

# 提交更改
echo "提交更改：$COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# 推送更改到远程仓库
echo "推送更改到远程仓库..."
if git push origin main; then
    echo "成功推送至 GitHub！"
else
    echo "推送失败，请检查网络或 GitHub 配置（例如分支名称是否正确）。"
    echo "默认分支可能是 'main'，如果你的默认分支是 'master' 或其他，请手动推送："
    echo "  git push origin <分支名>"
    exit 1
fi