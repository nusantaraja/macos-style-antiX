#!/bin/bash

echo "🔊 Memulai setup sound login/logout ala macOS..."
sleep 2

# === 1. Install paket pendukung ===
echo "📦 Menginstal paket audio pendukung..."
sudo apt install -y pulseaudio paplay libcanberra-gtk-module

# === 2. Buat direktori untuk file suara ===
SOUND_DIR="$HOME/.macos_sounds"
mkdir -p "$SOUND_DIR"

# === 3. Download sound macOS ===
cd "$SOUND_DIR"
echo "📥 Mengunduh sound macOS..."

wget -O boot.wav https://github.com/rafaelvasco/macOS-Startup-Sound/raw/master/sounds/Startup_16_bit_PCM.wav 
wget -O login.wav https://github.com/rafaelvasco/macOS-Startup-Sound/raw/master/sounds/Login_16_bit_PCM.wav 
wget -O logout.wav https://github.com/rafaelvasco/macOS-Startup-Sound/raw/master/sounds/Logout_16_bit_PCM.wav 

chmod 644 *.wav

# === 4. Setup sound saat login (via autostart) ===
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

cat > "$AUTOSTART_DIR/play-login-sound.desktop" <<EOL
[Desktop Entry]
Type=Application
Exec=sh -c "sleep 3 && paplay $SOUND_DIR/login.wav"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Play Login Sound
Comment=Play macOS-like login sound at startup
EOL

# === 5. Setup sound saat logout (memerlukan script khusus) ===
LOGOUT_SCRIPT="$HOME/.logout-sound.sh"

cat > "$LOGOUT_SCRIPT" <<EOL
#!/bin/bash
paplay $SOUND_DIR/logout.wav &
exit 0
EOL

chmod +x "$LOGOUT_SCRIPT"

# Tambahkan ke session logout hook (hanya bekerja jika WM mendukung)
if [ -d "/etc/xdg/autostart" ]; then
    cat > "$AUTOSTART_DIR/play-logout-sound.desktop" <<EOL
[Desktop Entry]
Type=Application
Exec=$LOGOUT_SCRIPT
NotShowIn=GNOME;KDE;
X-GNOME-Autostart-Phase=Shutdown
Name=Play Logout Sound
Comment=Play macOS-like logout sound
EOL
fi

# Jika tidak didukung logout hook, bisa tambahkan tombol custom atau keyboard shortcut
echo "💡 Jika logout sound tidak aktif otomatis, kamu bisa tambahkan shortcut manual di Settings > Keyboard."

# === Selesai ===
echo ""
echo "🎉 Setup sound login/logout selesai!"
echo "📌 Silakan logout dan login ulang untuk uji coba."
echo "👉 Sound login/logout macOS-like siap menemani pengalaman desktop kamu."
