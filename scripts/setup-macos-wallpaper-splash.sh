#!/bin/bash

echo "🖼️ Memulai setup wallpaper & splash screen macOS-like..."
sleep 2

# === 1. Buat direktori wallpaper ===
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$WALLPAPER_DIR"

# === 2. Download wallpaper macOS ===
cd "$WALLPAPER_DIR"
echo "📥 Mengunduh wallpaper macOS..."

wget https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/Catalina/4K/Catalina%20Dynamic.png  -O catalina-dynamic.png
wget https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/BigSur/4K/BigSur%20Dynamic.png  -O bigsur-dynamic.png
wget https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/Monterey/4K/Monterey%20Dynamic.png  -O monterey-dynamic.png

# === 3. Set wallpaper default (pilih salah satu) ===
echo "🖥️ Menerapkan wallpaper macOS..."
feh --bg-scale "$WALLPAPER_DIR/catalina-dynamic.png"

# === 4. Tambahkan ke autostart agar tetap aktif setelah reboot ===
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/set-wallpaper.desktop" <<EOL
[Desktop Entry]
Type=Application
Exec=feh --bg-scale $WALLPAPER_DIR/catalina-dynamic.png
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Set Wallpaper
Comment=Apply macOS-style wallpaper at startup
EOL

# === 5. Install Plymouth untuk custom splash screen ===
echo "🎨 Menginstal Plymouth untuk splash screen..."
sudo apt install -y plymouth plymouth-themes

# === 6. Download splash screen ala macOS ===
cd /tmp
echo "📥 Mengunduh splash screen macOS..."
git clone https://github.com/adi1090x/plymouth-theme-macos.git 
cd plymouth-theme-macos
chmod +x install.sh
sudo ./install.sh

# === 7. Set Plymouth sebagai theme default ===
echo "🔄 Mengatur Plymouth sebagai splash screen default..."
sudo update-alternatives --set default.plymouth /lib/plymouth/themes/macos/macos.plymouth
sudo plymouth-set-default-theme macos

# === 8. Update initramfs untuk menerapkan perubahan ===
echo "💾 Memperbarui initramfs..."
sudo update-initramfs -u

# === Selesai ===
echo ""
echo "🎉 Setup wallpaper & splash screen selesai!"
echo "📌 Silakan restart laptop untuk melihat hasilnya."
echo "👉 Wallpaper bisa diganti dengan bigsur-dynamic.png atau monterey-dynamic.png sesuai selera."
