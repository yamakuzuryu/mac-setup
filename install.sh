#!/usr/bin/env bash
#==========================================#
# Installer to setup up a Mac, Mike's Way! #
#==========================================#

# Import utils for text formatting
source "./utils/formatting.sh"

# Xcode Command Line Tools (now installed as part of the Homebrew installation)
# echo "Installing Xcode Command Line Tools..."
# xcode-select --install

# Select the native Homebrew prefix
if [ "$(uname -m)" = "arm64" ]; then
	BREW_PREFIX="/opt/homebrew"
else
	BREW_PREFIX="/usr/local"
fi

BREW_BIN="$BREW_PREFIX/bin/brew"

# Install Homebrew if the native installation is missing
if [ ! -x "$BREW_BIN" ]; then
	print_message "Installing Homebrew..." "$GREEN"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make the native Homebrew available to this script
if [ -x "$BREW_BIN" ]; then
	eval "$("$BREW_BIN" shellenv)"
else
	print_message "Homebrew installation failed." "$RED"
	exit 1
fi

# Install packages from Brewfile
print_message "Installing packages from Brewfile..." "$GREEN"
# "$BREW_BIN" bundle --file=./Brewfile --verbose
"$BREW_BIN" bundle --file=./Brewfile

# Install Starship configuration
print_message "Installing Starship configuration..." "$GREEN"
mkdir -p "$HOME/.config"

if [ -e "$HOME/.config/starship.toml" ]; then
	print_message "Starship configuration already exists. Skipping." "$YELLOW"
else
	cp "./starship.toml" "$HOME/.config/starship.toml"
	print_message "Starship configuration installed." "$GREEN"
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
