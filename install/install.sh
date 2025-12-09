#!/bin/bash
#
# Omarchy Dotfiles Setup Script
#
# This script installs packages and deploys configuration files.
#
# Manual steps are required for Firefox setup and for enabling services.
# See readme.md for more details.
#

# --- Stop on first error ---
set -e

# --- Configuration ---
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/setup_backup_$(date +%Y-%m-%d)"
PACMAN_PKGLIST="./pkglist.txt"
AUR_PKGLIST="./aur_pkglist.txt"

# --- Helper Functions ---
info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

warning() {
    echo -e "\033[1;33m[WARNING]\033[0m $1"
}

error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1" >&2
    exit 1
}

# --- Main Logic ---

# 1. Package Installation
info "Starting package installation..."
if [ ! -f "$PACMAN_PKGLIST" ] || [ ! -f "$AUR_PKGLIST" ]; then
    error "Package lists (pkglist.txt, aur_pkglist.txt) not found in the same directory as the script."
fi

info "Installing packages from official repositories (pacman)..."
sudo pacman -S --needed --noconfirm - < "$PACMAN_PKGLIST"

info "Installing packages from AUR (yay)..."
if ! command -v yay &> /dev/null; then
    error "'yay' is not installed. Please install it first."
fi
yay -S --needed --noconfirm - < "$AUR_PKGLIST"

info "Installing omarchy-theme-hook"
curl -fsSL https://imbypass.github.io/omarchy-theme-hook/install.sh | bash

info "Package installation complete."


# 2. Deploy Dotfiles with Backup
info "Deploying dotfiles from $DOTFILES_DIR to $HOME..."
if [ ! -d "$DOTFILES_DIR" ]; then
    error "Dotfiles directory not found at $DOTFILES_DIR."
fi
mkdir -p "$BACKUP_DIR"
info "Existing files will be backed up to $BACKUP_DIR"

rsync -av --exclude=".git" --exclude="*.md" --exclude="Package-install.txt" --exclude="tema-copy.txt" --exclude="install" \
      --backup --backup-dir="$BACKUP_DIR" \
      "$DOTFILES_DIR/" "$HOME/"

info "Dotfiles deployment complete."

info "Setup script finished successfully!"
echo "Please see readme.md for required manual steps (like Firefox setup and enabling services)."
exit 0
