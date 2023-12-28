#!/bin/bash
##########################################
# Script for setting up a MacOS machine  #
##########################################

# Xcode Command Line Tools (Homebrew installs this now)
# echo "Installing Xcode Command Line Tools..."
# xcode-select --install

# Homebrew
if test ! $(which brew); then
	echo "Installing Homebrew..."
	# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update existing recipes
brew update

# Upgrade existing formulae
brew upgrade

# Install packages from Brewfile
# brew bundle --file=~/Brewfile
brew bundle --global --verbose

brew cleanup
