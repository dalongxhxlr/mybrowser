#!/usr/bin/env bash
set -e

echo "=== 清理旧进程 ==="
pkill -9 epiphany || true
pkill -9 WebKitWebProcess || true
pkill -9 WebKitNetworkProcess || true
pkill -9 WebKitStorageProcess || true
pkill -9 Xvfb || true
pkill -9 x11vnc || true
pkill -9 websockify || true
pkill -9 xfce4-session || true
pkill -9 xfwm4 || true
pkill -9 xfdesktop || true
pkill -9 xfsettingsd || true
pkill -9 fcitx || true
sleep 1

echo "=== 设置时区 Asia/Shanghai (UTC+8) ==="
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "=== 启动 Xvfb ==="
Xvfb :1 -screen 0 1920x1080x24 -ac -nolisten tcp \
  +extension GLX +extension RANDR +extension RENDER &
sleep 1
export DISPLAY=:1

echo "=== 设置中文环境变量 ==="
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh
export LC_ALL=zh_CN.UTF-8
export LC_TIME=zh_CN.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

echo "=== 设置键盘布局 ==="
setxkbmap -layout us

echo "=== 启动 XFCE 桌面 ==="
startxfce4 &

echo "=== 启动中文输入法 fcitx ==="
fcitx &

echo "=== 启动 x11vnc ==="
x11vnc -display :1 -forever -nopw -xkb -noxrecord -noxfixes -noxdamage -repeat -shared -nosel &

echo "=== 创建 Falkon 浏览器快捷方式 ==="
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/falkon.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Falkon 浏览器
Exec=falkon
Icon=web-browser
Terminal=false
EOF
chmod +x ~/.local/share/applications/falkon.desktop
cp ~/.local/share/applications/falkon.desktop ~/Desktop/ 2>/dev/null || true

echo "=== 启动 noVNC ==="
websockify --web=/usr/share/novnc/ 3000 localhost:5900
