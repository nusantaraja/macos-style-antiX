#!/bin/bash

echo "🎨 Memulai setup tema macOS-like untuk AntiX..."
sleep 2

# === 1. Update sistem ===
echo "🔄 Mengupdate daftar paket..."
sudo apt update && sudo apt upgrade -y

# === 2. Install tools pendukung ===
echo "📦 Menginstall tools pendukung..."
sudo apt install -y git curl unzip xf86-video-nvidia xcompmgr compton picom plank feh

# === 3. Buat direktori tema dan ikon ===
THEME_DIR="$HOME/.themes"
ICON_DIR="$HOME/.icons"
FONT_DIR="$HOME/.fonts"

mkdir -p "$THEME_DIR" "$ICON_DIR" "$FONT_DIR"

# === 4. Download Tema macOS-like (WhiteSur) ===
echo "🖼️ Mengunduh tema WhiteSur GTK..."
cd "$THEME_DIR"
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git 
cd WhiteSur-gtk-theme
./install.sh --tweaks roundify

# === 5. Download Ikon macOS-like (Cupertino) ===
echo "🔖 Mengunduh ikon Cupertino..."
cd "$ICON_DIR"
git clone https://github.com/ful1e5/Cupertino-icon-theme.git 
mv Cupertino-icon-theme/cupertino

# === 6. Download Font San Francisco Alternatif (Roboto + SF Pro) ===
echo "🔤 Mengunduh font alternatif..."
cd "$FONT_DIR"
wget https://github.com/itfoundry/sfpro/raw/master/SF-Pro-Display-Regular.otf 
wget https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Regular.ttf 

# === 7. Install Font ===
fc-cache -fv

# === 8. Setup Plank Dock (mirip macOS Dock) ===
echo "🚀 Mengatur Plank Dock..."
mkdir -p "$HOME/.config/plank/themes"
cd "$HOME/.config/plank/themes"
git clone https://github.com/ful1e5/Plank-Themes.git 
mv Plank-Themes/macOS-dock .
ln -s "$HOME/.config/plank/themes/macOS-dock" "$HOME/.local/share/plank/themes/macOS-dock"

# Buat config plank
mkdir -p "$HOME/.config/autostart"
cat > "$HOME/.config/autostart/plank.desktop" <<EOL
[Desktop Entry]
Type=Application
Exec=plank --theme macOS-dock --nodaemon
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Plank Dock
Comment=Start Plank with macOS theme
EOL

# === 9. Setup Picom (efek transparansi & drop shadow) ===
echo "✨ Mengaktifkan efek desktop dengan Picom..."
sudo apt install -y picom
mkdir -p "$HOME/.config/picom"
cat > "$HOME/.config/picom.conf" <<EOL
backend = "glx";
paint-on-overlay = true;
glx-no-stencil = true;
glx-swap-method = "undefined";

shadow = true;
shadow-radius = 15;
shadow-offset-x = -15;
shadow-offset-y = -15;
shadow-opacity = 0.3;

fading = true;
fade-delta = 10;
fade-in-step = 0.03;
fade-out-step = 0.03;

EOL

# Tambahkan ke autostart
cat >> "$HOME/.config/autostart/picom.desktop" <<EOL
[Desktop Entry]
Type=Application
Exec=picom --config ~/.config/picom.conf --no-fading-openclose
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Picom Compositor
Comment=Enable transparency and shadows
EOL

# === 10. Apply tema via command line (gunakan xfconf jika Xfce) ===
echo "🖥️ Menerapkan tema..."
xfconf-query -c xsettings -p /Net/ThemeName -s "WhiteSur-Dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "cupertino"
xfconf-query -c xsettings -p /Gtk/FontName -s "Roboto 10"

# === Selesai ===
echo ""
echo "🎉 Setup tema macOS selesai!"
echo "📌 Silakan restart session atau reboot laptop."
echo "👉 Buka 'Look and Feel' atau 'Appearance Settings' untuk fine-tuning tambahan."
