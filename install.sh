#!/usr/bin/env bash
#==========================================#
# Installer to setup up a Mac, Mike's Way! #
#==========================================#

# Import utils for text formatting
source "./utils/formatting.sh"

# Xcode Command Line Tools (now installed as part of the Homebrew installation)
# echo "Installing Xcode Command Line Tools..."
# xcode-select --install

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
	print_message "Installing Homebrew..." "$GREEN"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile
print_message "Installing packages from Brewfile..." "$GREEN"
brew bundle --file=./Brewfile --verbose

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	print_message "Installing Oh My Zsh..." "$GREEN"
	# Use RUNZSH=no to prevent Oh My Zsh from starting a new shell session after installation
	RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	print_message "Oh My Zsh is already installed. Skipping installation." "$YELLOW"
fi

# Setup dotfiles
print_message "Setting up dotfiles..." "$GREEN"
chmod +x ./setup_dotfiles.sh
./setup_dotfiles.sh

# Configure VSCode CLI
print_message "Configuring VSCode CLI..." "$GREEN"
if [ -d "/Applications/Visual Studio Code.app" ]; then
	# Create symbolic link to VS Code CLI in /usr/local/bin
	if [ ! -f "/usr/local/bin/code" ]; then
		print_message "Creating symbolic link for VS Code CLI..." "$GREEN"
		ln -s "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "/usr/local/bin/code"
		print_message "VS Code CLI command 'code' has been set up." "$GREEN"
	else
		print_message "VS Code CLI command 'code' is already set up." "$YELLOW"
	fi
else
	print_message "Visual Studio Code is not installed in /Applications. Skipping VS Code CLI setup." "$YELLOW"
fi

print_message "Setup complete! Please restart your terminal." "$GREEN"
