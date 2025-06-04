# about

## 当前代码的可维护性

1. **添加项目或文章**：只需在 `data.projects` 或 `data.blog` 中添加一个新对象。例如，添加一个新项目：
   ```javascript
   { url: "https://github.com/yuuniji/new-project", label: { zh: "项目4 - 新项目", en: "Project 4 - New Project", ja: "プロジェクト4 - 新プロジェクト" } }
   ```
2. **修改现有条目**：直接编辑 `data` 中的对应对象。例如，修改"项目1"的标题：
   ```javascript
   { url: "https://github.com/yuuniji/yuuniji.github.io", label: { zh: "项目1 - 我的新博客", en: "Project 1 - My New Blog", ja: "プロジェクト1 - 私の新しいブログ" } }
   ```
3. **删除条目**：从 `data.projects` 或 `data.blog` 中移除对应对象即可。


## 脚本

 GitHub 用户名是 `yuuniji`，并且希望使用这个名字作为 Git 的用户名，并确保脚本适用于你的仓库 `https://github.com/yuuniji/about.git` 和邮箱 `yuuniji81@gmail.com`。

以下是更新后的脚本：

```bash
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
```

### 提交步骤
1. **确保环境准备好**：
   - 确认你已经在本地克隆了仓库，或者在正确的目录下：
     ```bash
     git clone https://github.com/yuuniji/about.git
     cd about
     ```
   - 如果是新项目，先初始化：
     ```bash
     git init
     git remote add origin https://github.com/yuuniji/about.git
     ```

2. **保存你的作品集页面**：
   - 确保你之前的 HTML 文件（作品集页面）已经保存到 `about` 目录下，例如保存为 `index.html`。

3. **保存脚本**：
   - 将上述脚本保存为 `github_one_click_push.sh`。

4. **赋予执行权限**：
   ```bash
   chmod +x github_one_click_push.sh
   ```

5. **运行脚本**：
   - 如果你想用默认提交信息（带时间戳），直接运行：
     ```bash
     ./github_one_click_push.sh
     ```
   - 或者提供自定义提交信息，例如：
     ```bash
     ./github_one_click_push.sh "更新作品集页面"
     ```

### 脚本更新说明
- **用户名更新**：将 Git 用户名设置为 `yuuniji`，与你的 GitHub 用户名一致。脚本会检查当前配置，如果不匹配，会自动更新：
  ```bash
  git config --global user.name "yuuniji"
  ```
- **邮箱**：保持邮箱为 `yuuniji81@gmail.com`，并添加检查和自动更新逻辑。
- **远程仓库**：脚本会提示添加 `https://github.com/yuuniji/about.git` 作为远程仓库。
- **分支**：默认推送分支为 `main`，如果你的仓库使用 `master` 或其他分支，脚本会提示手动推送。

### 注意事项
- **认证问题**：如果推送时遇到认证失败，GitHub 不再支持密码认证，建议使用以下方法：
  - **Personal Access Token (PAT)**：
    1. 在 GitHub 上生成一个 PAT（Settings > Developer settings > Personal access tokens）。
    2. 推送时输入用户名 `yuuniji`，密码使用 PAT。
  - **SSH 密钥**：
    1. 生成 SSH 密钥：
       ```bash
       ssh-keygen -t ed25519 -C "yuuniji81@gmail.com"
       ```
    2. 将公钥添加到 GitHub（Settings > SSH and GPG keys）。
    3. 更新远程 URL 为 SSH：
       ```bash
       git remote set-url origin git@github.com:yuuniji/about.git
       ```
- **同步远程更改**：如果推送失败（例如提示 `non-fast-forward`），先运行：
  ```bash
  git pull origin main
  ```
  然后再运行脚本。

# 个人作品集网站更新日志

## 2025-06-04 更新

### 1. 视觉优化

#### 终端窗口阴影效果
- 添加了多层阴影效果，创造更自然的深度感
- 优化了深色模式下的阴影效果
- 改进了边框和背景的透明度处理

#### 字体渲染优化
- 添加了 `-webkit-font-smoothing: antialiased` 和 `-moz-osx-font-smoothing: grayscale` 属性
- 优化了字体选择，使用更清晰的等宽字体
- 改进了文字间距和行高

#### 动画过渡效果
- 添加了终端窗口出现时的动画效果（terminalAppear）
- 为每个命令行添加了渐入动画（rowAppear）
- 优化了所有过渡效果，使用更自然的贝塞尔曲线
- 添加了按钮悬停效果
- 链接添加了平滑的悬停动画

#### 交互效果优化
- 改进了链接的悬停效果，添加了轻微的上浮动画
- 优化了按钮的反馈效果
- 添加了更多的状态过渡效果

#### 深色模式优化
- 优化了深色模式下的颜色对比度
- 改进了深色模式下的阴影效果
- 调整了深色模式下的边框和背景透明度

#### 响应式设计优化
- 优化了移动设备上的阴影效果
- 改进了小屏幕下的间距和布局

### 2. 国际化优化

#### 语言自动检测
- 实现了基于浏览器语言设置的自动语言检测
- 支持多种语言变体（如 'zh-CN'、'zh-TW'、'en-US' 等）
- 实现了语言匹配的优先级系统：
  1. 完全匹配（如 'zh-CN'）
  2. 基础语言匹配（如 'zh'）
  3. 默认使用中文

#### 语言选择记忆
- 使用 `localStorage` 保存用户的语言选择
- 在页面加载时优先使用保存的语言设置
- 当用户切换语言时，自动保存新的选择

### 3. 导航系统优化

#### 键盘导航改进
- 使用方向键进行项目选择
- 使用 Enter 键确认选择
- 保留了 Tab 键在元素间导航的功能
- 当项目数量小于等于 9 个时，支持数字键快速导航

#### 导航提示优化
- 添加了更清晰的导航提示信息
- 优化了提示的显示和隐藏动画
- 支持多语言导航提示

## 技术细节

### 语言映射表
```javascript
const langMap = {
    'zh': 'zh',
    'zh-CN': 'zh',
    'zh-TW': 'zh',
    'zh-HK': 'zh',
    'en': 'en',
    'en-US': 'en',
    'en-GB': 'en',
    'ja': 'ja',
    'ja-JP': 'ja'
};
```

### 动画效果
```css
@keyframes terminalAppear {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes rowAppear {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
```

### 阴影效果
```css
box-shadow: 
    0 2px 4px rgba(0, 0, 0, 0.02),
    0 4px 8px rgba(0, 0, 0, 0.02),
    0 8px 16px rgba(0, 0, 0, 0.02),
    0 16px 32px rgba(0, 0, 0, 0.02),
    0 0 0 1px rgba(0, 0, 0, 0.05);
```
