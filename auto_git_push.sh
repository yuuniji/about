#!/bin/bash

# 定义提交信息
default_message="Auto commit on $(date +'%Y-%m-%d %H:%M:%S')"
commit_message="${1:-$default_message}"

# 进入仓库目录（可选，确保在正确的 Git 目录执行）
# cd /path/to/your/repo

# 检查是否为 Git 仓库
if [ ! -d .git ]; then
    echo "Error: 当前目录不是一个 Git 仓库。"
    exit 1
fi

# 确保本地仓库是从 git clone 而来的
if ! git remote -v | grep -q "origin"; then
    echo "Error: 当前仓库没有设置远程 origin。"
    exit 1
fi

# 拉取最新代码，避免冲突
git pull origin $(git rev-parse --abbrev-ref HEAD) --rebase

# 添加所有修改和新增文件
git add .

# 提交更改
git commit -m "$commit_message"

# 推送到远程仓库
git push origin $(git rev-parse --abbrev-ref HEAD)

echo "✅ 代码已提交并推送到远程仓库！"
