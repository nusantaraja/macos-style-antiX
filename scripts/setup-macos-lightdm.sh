#!/bin/bash

echo "🔐 Memulai setup login screen LightDM ala macOS..."
sleep 2

# === 1. Install LightDM dan GTK greeter jika belum terinstall ===
echo "📦 Menginstal LightDM dan komponen pendukung..."
sudo apt install -y lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings

# === 2. Backup konfigurasi lama LightDM ===
echo "🔄 Membuat backup konfigurasi LightDM..."
sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
sudo cp /etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf.bak

# === 3. Buat direktori tema login screen ===
THEME_DIR="/usr/share/themes/MacOS-LightDM"
WALLPAPER_DIR="/usr/share/images/desktop-base"

sudo mkdir -p "$THEME_DIR" "$WALLPAPER_DIR/mac_lightdm"

# === 4. Download wallpaper login screen macOS-like ===
cd "$WALLPAPER_DIR/mac_lightdm"
echo "📥 Mengunduh wallpaper login screen macOS..."

sudo wget https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/Catalina/4K/Catalina%20Dynamic.png  -O catalina-login.png
sudo chmod 644 catalina-login.png

# === 5. Download tema LightDM minimal macOS ===
cd /tmp
echo "📥 Mengunduh tema LightDM minimal macOS..."
git clone https://github.com/keeferrourke/gtk3-mac.git 
cd gtk3-mac
sudo cp -r mac "$THEME_DIR/"

# === 6. Konfigurasi LightDM menggunakan tema macOS ===
echo "🎨 Mengatur konfigurasi LightDM..."

# Edit lightdm.conf
echo "[Seat:*]
greeter-session=lightdm-gtk-greeter" | sudo tee /etc/lightdm/lightdm.conf > /dev/null

# Edit lightdm-gtk-greeter.conf
echo "[greeter]
background=$WALLPAPER_DIR/mac_lightdm/catalina-login.png
theme-name=MacOS-LightDM
icon-theme-name=cupertino
font-name=Roboto 10
xft-antialias=true
xft-dpi=96
xft-hintstyle=slight
xft-rgba=rgb
show-language=false
show-power=true" | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null

# === 7. Restart LightDM untuk lihat hasilnya ===
echo "🔄 Merestart layanan LightDM..."
sudo systemctl restart lightdm

# === Selesai ===
echo ""
echo "🎉 Setup login screen LightDM selesai!"
echo "📌 Silakan logout atau reboot untuk melihat hasilnya."
echo "👉 Tampilan login screen sekarang mirip macOS dengan wallpaper Catalina."
