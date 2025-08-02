#!/usr/bin/env bash
##########################################
# Installer to setup up a Mac, Mike's Way!
##########################################

# Xcode Command Line Tools (now installed as part of the Homebrew installation)
# echo "Installing Xcode Command Line Tools..."
# xcode-select --install

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile
echo "Installing packages from Brewfile..."
brew bundle --file=./Brewfile --verbose
