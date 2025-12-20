FLATPAKS=(
  "apps/com.discordapp.Discord"
  "apps/md.obsidian.Obsidian"
  "app/org.chromium.Chromium/x86_64/stable"
  "apps/org.kde.kdenlive"
)

for pak in "${FLATPAKS[@]}"; do
  if ! flatpak list | grep -i "$pak" &> /dev/null; then
    echo "Installing Flatpak: $pak"
    flatpak install --noninteractive "$pak"
  else
    echo "Flatpak already installed: $pak"
  fi
done
