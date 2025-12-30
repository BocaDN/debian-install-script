#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"
    _            __        ____                            _       __ 
   (_)___  _____/ /_____ _/ / /            _______________(_)___  / /_
  / / __ \/ ___/ __/ __ `/ / /   ______   / ___/ ___/ ___/ / __ \/ __/
 / / / / (__  ) /_/ /_/ / / /   /_____/  (__  ) /__/ /  / / /_/ / /_  
/_/_/ /_/____/\__/\__,_/_/_/            /____/\___/_/  /_/  ___/\__/  
                                                        /__/
EOF
}

# Parse command line arguments
DEV_ONLY=false
ZSH_BREW_ONLY=false
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --dev-only) DEV_ONLY=true; shift ;;
    --zsh-brew-only) ZSH_BREW_ONLY=true; shift ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
done

# Clear screen and show logo
clear
print_logo

# Exit on any error
set -e

# Source utility functions
source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

if [[ "$DEV_ONLY" == true ]]; then
  echo "Starting development-only setup..."
else
  echo "Starting full system setup..."
fi


zsh_and_brew_setup() {
  # install oh-my-zsh
  echo "Install brew"
  NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
  [ -d /home/linuxbrew/.linuxbrew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc zsh-syntax-highlighting zsh-autosuggestions
  # (
  # set +e
  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
  # )
}

# Update the system first
echo "Updating system..."
sudo apt update -y

# Install packages by category
if [[ "$DEV_ONLY" == true ]]; then
  # Only install essential development packages
  echo "Installing system utilities..."
  install_packages "${SYSTEM_UTILS[@]}"
  
  echo "Installing development tools..."
  install_packages "${DEV_TOOLS[@]}"
  zsh_and_brew_setup
elif [[ "$ZSH_BREW_ONLY" == true ]]; then
  zsh_and_brew_setup
else
  # Install all packages
  echo "Installing system utilities..."
  install_packages "${SYSTEM_UTILS[@]}"
  
  echo "Installing development tools..."
  install_packages "${DEV_TOOLS[@]}"
  
  echo "Installing system maintenance tools..."
  install_packages "${MAINTENANCE[@]}"
  
  echo "Installing desktop environment..."
  install_packages "${DESKTOP[@]}"
  
  echo "Installing desktop environment..."
  install_packages "${OFFICE[@]}"
  
  echo "Installing media packages..."
  install_packages "${MEDIA[@]}"
  
  echo "Installing fonts..."
  install_packages "${FONTS[@]}"
  
  # Enable services
  echo "Configuring services..."
  for service in "${SERVICES[@]}"; do
    if ! systemctl is-enabled "$service" &> /dev/null; then
      echo "Enabling $service..."
      sudo systemctl enable "$service"
    else
      echo "$service is already enabled"
    fi
  done
  

  zsh_and_brew_setup
  # Some programs just run better as flatpaks. Like discord/spotify
  echo "Installing flatpaks (like discord and spotify)"
  . install-flatpaks.sh
fi

echo "Setup complete! You may want to reboot your system."
