#!/usr/bin/env bash
set -e

echo "=== 更新软件源 ==="
sudo apt update || true

echo "=== 安装 Falkon 浏览器 ==="
sudo apt install -y falkon

echo "=== 安装中文语言包 ==="
sudo apt install -y language-pack-zh-hans

echo "=== 安装中文字体 ==="
sudo apt install -y fonts-wqy-zenhei fonts-wqy-microhei

echo "=== 安装中文输入法 fcitx + 拼音 ==="
sudo apt install -y fcitx fcitx-pinyin fcitx-table fcitx-table-wubi

echo "=== 安装 noVNC 和 x11vnc ==="
sudo apt install -y novnc websockify x11vnc

echo "=== 安装 XFCE 桌面环境 ==="
sudo apt install -y xfce4 xfce4-goodies

echo "=== 安装 Xvfb 虚拟显示器 ==="
sudo apt install -y xvfb

echo "=== 生成中文 UTF-8 locale ==="
sudo locale-gen zh_CN.UTF-8

echo "=== 设置默认时区为 Asia/Shanghai (UTC+8) ==="
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "=== 初始化完成 ==="
