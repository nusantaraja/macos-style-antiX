#!/bin/bash

PACKAGE_NAME="antix-macos-style-package"
ZIP_NAME="${PACKAGE_NAME}.zip"

echo "📦 Membuat direktori kerja..."
mkdir -p "$PACKAGE_NAME/scripts" "$PACKAGE_NAME/themes" \
         "$PACKAGE_NAME/wallpapers" "$PACKAGE_NAME/sounds"

# === Salin script ===
cp setup-macos-theme.sh setup-macos-wallpaper-splash.sh \
   setup-macos-lightdm.sh setup-macos-sound.sh "$PACKAGE_NAME/scripts/"

# === Clone tema ===
cd "$PACKAGE_NAME/themes"
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git 
git clone https://github.com/ful1e5/Cupertino-icon-theme.git 
mv Cupertino-icon-theme cupertino

# === Download wallpaper ===
cd "../wallpapers"
wget -O catalina-dynamic.png https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/Catalina/4K/Catalina%20Dynamic.png 
wget -O bigsur-dynamic.png https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/BigSur/4K/BigSur%20Dynamic.png 
wget -O monterey-dynamic.png https://github.com/ful1e5/backgrounds.macintosh.dev/raw/main/Monterey/4K/Monterey%20Dynamic.png 

# === Download sound ===
cd "../sounds"
wget -O boot.wav https://github.com/rafaelvasco/macOS-Startup-Sound/raw/master/sounds/Startup_16_bit_PCM.wav 
wget -O login.wav https://github.com/rafaelvasco/macOS-Startup-Sound/raw/master/sounds/Login_16_bit_PCM.wav 
wget -O logout.wav https://github.com/rafaelvasco/macOS-Startup-Sound/raw/master/sounds/Logout_16_bit_PCM.wav 

# === Buat README ===
cd ..
cat > README.md <<EOL
# AntiX macOS Style Package

Paket ini berisi:
- Script setup tema, wallpaper, splash screen, login screen, dan sound
- Tema WhiteSur (GTK), Cupertino (ikon)
- Wallpaper macOS: Catalina, Big Sur, Monterey
- Sound efek login/logout

## ✅ Cara Gunakan

1. Ekstrak zip
2. Jalankan script sesuai urutan:
   - `scripts/setup-macos-theme.sh`
   - `scripts/setup-macos-wallpaper-splash.sh`
   - `scripts/setup-macos-lightdm.sh`
   - `scripts/setup-macos-sound.sh`

> Pastikan semua dependensi terinstall sebelum jalankan script.

Enjoy your macOS-like AntiX!
EOL

# === Buat ZIP ===
echo "🗜️ Mengarsipkan ke $ZIP_NAME..."
zip -r "$ZIP_NAME" "$PACKAGE_NAME"

echo ""
echo "🎉 Paket selesai dibuat: $ZIP_NAME"
echo "📌 Silakan bagikan atau gunakan secara offline."
