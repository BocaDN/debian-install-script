#!/bin/bash

# Check if a package is installed (Debian/Ubuntu)
is_installed() {
  dpkg -s "$1" &> /dev/null
}

# Check if a metapackage is installed
is_group_installed() {
  dpkg -s "$1" &> /dev/null
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg" && ! is_group_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    apt-get install -y "${to_install[@]}"
  fi
} 
