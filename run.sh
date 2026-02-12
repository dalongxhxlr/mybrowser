#!/usr/bin/env bash
set -e

echo "=== Step 1: 执行 setup.sh 安装依赖环境 ==="
chmod +x setup.sh
./setup.sh

echo "=== Step 2: 执行 start.sh 启动虚拟桌面 ==="
chmod +x start.sh
./start.sh
