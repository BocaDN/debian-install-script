FLATPAKS=(
  "com.discordapp.Discord"
  "md.obsidian.Obsidian"
  "org.chromium.Chromium/x86_64/stable"
  "org.kde.kdenlive"
)

for pak in "${FLATPAKS[@]}"; do
  if ! flatpak list | grep -i "$pak" &> /dev/null; then
    echo "Installing Flatpak: $pak"
    flatpak install --noninteractive "$pak"
  else
    echo "Flatpak already installed: $pak"
  fi
done
