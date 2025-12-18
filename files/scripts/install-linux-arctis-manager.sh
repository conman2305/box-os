#!/bin/bash
set -ouex pipefail

# Clone the repository
git clone https://github.com/elegos/Linux-Arctis-Manager.git /tmp/Linux-Arctis-Manager
cd /tmp/Linux-Arctis-Manager
git checkout v1.6.3

# Build dependencies
# We need pipenv to manage the build environment as per the upstream method
pip install --upgrade pipenv

# Install project dependencies in a virtualenv managed by pipenv
# -d installs dev dependencies which might be needed for pyinstaller
# Install project dependencies
# -d installs dev dependencies which might be needed for pyinstaller
pipenv --python /usr/bin/python3.13 install -d
# Explicitly install pyinstaller to ensure it is available in the virtualenv
pipenv install pyinstaller

# Build the binaries using pyinstaller
echo "Building binaries..."
pipenv run pyinstaller arctis-manager.spec
pipenv run pyinstaller arctis-manager-launcher.spec

# We don't need the virtualenv anymore
pipenv --rm

# Install Files
echo "Installing files..."

# 1. Binaries
install -Dm755 dist/arctis-manager /usr/bin/arctis-manager
install -Dm755 dist/arctis-manager-launcher /usr/bin/arctis-manager-launcher

# 2. Desktop File
install -Dm644 ArctisManager.desktop /usr/share/applications/ArctisManager.desktop

# 3. Icon
install -Dm644 arctis_manager/images/steelseries_logo.svg /usr/share/icons/hicolor/scalable/apps/arctis_manager.svg

# 4. Udev Rules
install -Dm644 udev/91-steelseries-arctis.rules /usr/lib/udev/rules.d/91-steelseries-arctis.rules

# 5. Systemd Service
# The service is enabled in recipe.yml via the systemd module
install -Dm644 systemd/arctis-manager.service /usr/lib/systemd/user/arctis-manager.service

# Clean up
cd /
rm -rf /tmp/Linux-Arctis-Manager
pip uninstall -y pipenv
