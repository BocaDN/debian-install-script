#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/BocaDN/dotfiles"
REPO_NAME="dotfiles"


is_stow_installed() {
  dpkg -s stow &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME"
  stow --adopt -t ~ zshrc
  stow --adopt -t ~ nvim
  stow --adopt -t ~ i3
  stow --adopt -t ~ local
  stow --adopt -t ~ tmux
else
  echo "Failed to clone the repository."
  exit 1
fi

