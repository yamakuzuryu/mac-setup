#!/usr/bin/env bash
#==========================================#
# Installer to setup up a Mac, Mike's Way! #
#==========================================#

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

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Installing Oh My Zsh..."
	# Use RUNZSH=no to prevent Oh My Zsh from starting a new shell session after installation
	RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "Oh My Zsh is already installed. Skipping installation."
fi

# Setup dotfiles
echo "Setting up dotfiles..."
chmod +x ./setup_dotfiles.sh
./setup_dotfiles.sh

# Configure VSCode CLI
echo "Configuring VSCode CLI..."
if [ -d "/Applications/Visual Studio Code.app" ]; then
	# Create symbolic link to VS Code CLI in /usr/local/bin
	if [ ! -f "/usr/local/bin/code" ]; then
		echo "Creating symbolic link for VS Code CLI..."
		ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "/usr/local/bin/code"
		echo "VS Code CLI command 'code' has been set up."
	else
		echo "VS Code CLI command 'code' is already set up."
	fi
else
	echo "Visual Studio Code is not installed in /Applications. Skipping VS Code CLI setup."
fi

echo "Setup complete! Please restart your terminal."
