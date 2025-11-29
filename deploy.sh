#!/bin/bash

# ==========================================
# Astro Blog 纯容器化部署脚本 (Rei Edition ✨)
# ==========================================
# 特点：宿主机无需 Node/Git，一切在容器内完成

# --- 配置区域 ---
REPO_URL="https://github.com/kobayashirei/blog.git" 
APP_NAME="astro-blog"
CONTAINER_NAME="astro-blog-container"
PORT=4000
CONTAINER_INNER_APP_PORT=4000

# 获取当前脚本所在目录的绝对路径 (兼容 Windows Git Bash)
# 这里的 pwd -W 是 Git Bash 特有的，如果报错则回退到 pwd
if [[ "$OSTYPE" == "msys" ]]; then
    CURRENT_DIR=$(pwd -W)
else
    CURRENT_DIR=$(pwd)
fi

# 定义挂载到容器的工作目录
WORKSPACE_DIR="$CURRENT_DIR/workspace"
# 最终构建产物的宿主机路径
DIST_DIR="$WORKSPACE_DIR/$APP_NAME/dist"

# --- 脚本开始 ---

echo "🚀 (Rei) 全容器化部署模式启动！"
echo "📂 工作目录: $WORKSPACE_DIR"

# 1. 准备工作目录
mkdir -p "$WORKSPACE_DIR"

# 2. 启动 Builder 容器 (Node 环境)
# 使用 node:20-alpine 作为构建环境，它轻量且包含 corepack
echo "🐳 [Builder] 启动 Node.js 容器进行构建..."
echo "   - 任务: Git Clone -> PNPM Install -> PNPM Build"

docker run --rm \
    -v "$WORKSPACE_DIR:/app" \
    -w /app \
    node:20-alpine \
    sh -c "
    set -e # 遇到错误立即退出

    echo '🔧 [Container] 安装 Git...'
    apk add --no-cache git > /dev/null

    echo '📦 [Container] 启用 PNPM...'
    corepack enable
    corepack prepare pnpm@latest --activate

    if [ ! -d \"$APP_NAME\" ]; then
        echo '� [Container] 克隆仓库...'
        git clone \"$REPO_URL\" \"$APP_NAME\"
    else
        echo '🔄 [Container] 更新仓库...'
        cd \"$APP_NAME\"
        # 判断是否为 git 仓库，防止报错
        if [ -d \".git\" ]; then
            git pull
        else
            echo '⚠️ [Container] 目录异常，重新克隆...'
            cd ..
            rm -rf \"$APP_NAME\"
            git clone \"$REPO_URL\" \"$APP_NAME\"
        fi
        cd ..
    fi

    cd \"$APP_NAME\"

    echo '📦 [Container] 安装依赖 (pnpm install)...'
    pnpm install --frozen-lockfile || pnpm install

    echo '🏗️ [Container] 打包构建 (pnpm run build)...'
    pnpm run build
    
    # 修改文件权限，防止宿主机无法操作 (可选，视情况而定)
    # chmod -R 777 dist
    "

# 检查构建容器的退出码
if [ $? -ne 0 ]; then
    echo "❌ (Rei) 构建过程中出现了错误，脚本终止。"
    exit 1
fi

# 3. 检查产物
if [ ! -d "$DIST_DIR" ]; then
    echo "❌ (Rei) 未找到构建产物 dist 目录，请检查构建日志。"
    exit 1
fi

echo "✅ 构建成功！产物位于: $DIST_DIR"

# 4. 启动 Runner 容器 (Nginx)
echo "🚀 [Runner] 部署 Nginx 容器..."

# 停止旧容器
if [ "$(docker ps -aq -f name="$CONTAINER_NAME")" ]; then
    echo "🛑 停止旧容器..."
    docker rm -f "$CONTAINER_NAME"
fi

# 启动新容器
# 直接使用 nginx:alpine 镜像，无需构建新镜像，挂载 dist 即可
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "$PORT":"$CONTAINER_INNER_APP_PORT" \
  -v "$DIST_DIR":/usr/share/nginx/html \
  nginx:alpine

echo "=========================================="
echo "✨ 部署完成啦！所有操作都在容器内搞定！"
echo "📂 你的代码保存在: ./workspace/$APP_NAME"
echo "📂 宿主机映射目录: $DIST_DIR"
echo "🌍 访问地址: http://localhost:$PORT"
echo "=========================================="
