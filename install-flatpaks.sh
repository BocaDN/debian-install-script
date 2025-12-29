FLATPAKS=(
  "com.discordapp.Discord"
  "md.obsidian.Obsidian/x86_64/stable"
  "org.chromium.Chromium/x86_64/stable"
  "org.kde.kdenlive"
)


flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for pak in "${FLATPAKS[@]}"; do
  if ! flatpak list | grep -i "$pak" &> /dev/null; then
    echo "Installing Flatpak: $pak"
    flatpak install -y flathub "$pak"
  else
    echo "Flatpak already installed: $pak"
  fi
done
