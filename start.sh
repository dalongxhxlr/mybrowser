#!/usr/bin/env bash
set -e

echo "=== HARD CLEAN: killing all old processes ==="
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

echo "=== Removing Epiphany autostart entries ==="
rm -f ~/.config/autostart/epiphany.desktop || true
rm -f ~/.config/autostart/org.gnome.Epiphany.desktop || true
sudo rm -f /etc/xdg/autostart/epiphany.desktop 2>/dev/null || true
sudo rm -f /etc/xdg/autostart/org.gnome.Epiphany.desktop 2>/dev/null || true

echo "=== Removing Epiphany desktop entries ==="
rm -f ~/.local/share/applications/epiphany.desktop || true
sudo rm -f /usr/share/applications/epiphany.desktop 2>/dev/null || true
sudo rm -f /usr/share/applications/org.gnome.Epiphany.desktop 2>/dev/null || true

echo "=== Setting timezone to Asia/Shanghai (UTC+8) ==="
sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

echo "=== Starting Xvfb ==="
Xvfb :1 -screen 0 1920x1080x24 -ac -nolisten tcp \
  +extension GLX +extension RANDR +extension RENDER &
sleep 1

export DISPLAY=:1

echo "=== Setting Chinese locale ==="
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:zh
export LC_ALL=zh_CN.UTF-8
export LC_TIME=zh_CN.UTF-8

echo "=== Setting input method environment variables ==="
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

echo "=== Setting keyboard layout ==="
setxkbmap -layout us

echo "=== Starting XFCE desktop ==="
startxfce4 &

echo "=== Starting Chinese input method (fcitx) ==="
fcitx &

echo "=== Starting x11vnc ==="
x11vnc \
  -display :1 \
  -forever \
  -nopw \
  -xkb \
  -noxrecord \
  -noxfixes \
  -noxdamage \
  -repeat \
  -shared \
  -nosel \
  &

echo "=== Creating Falkon launcher ==="
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

echo "=== Starting noVNC ==="
websockify --web=/usr/share/novnc/ 3000 localhost:5900
