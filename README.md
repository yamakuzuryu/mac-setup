# Automate Mac Setup

A collection of scripts and configuration files to automate the setup of a new macOS machine with preferred tools, applications, and settings.

## Overview

This repository contains scripts to automate the process of setting up a new Mac with essential development tools, applications, and configurations. It simplifies the onboarding process for new machines and ensures consistent environments across different computers.

## Features

- **Homebrew Installation**: Automatically installs Homebrew and packages from the Brewfile
- **Application Installation**: Installs commonly used applications via Homebrew Casks and Mac App Store
- **Development Tools**: Sets up development tools including Git, Node.js, and more
- **Dotfiles Management**: Synchronizes dotfiles between computers via cloud storage (iCloud or Google Drive)
- **VS Code Configuration**: Installs VS Code extensions and sets up the CLI tool

## Getting Started

1. Clone this repository:

   ```bash
   git clone https://github.com/bohmanart/mac-setup.git
   cd mac-setup
   ```

2. Run the installation script:

   ```bash
   ./install.sh
   ```

3. To set up dotfiles (install.sh also sets up dotfiles):

   ```bash
   ./setup_dotfiles.sh
   ```

   Follow the prompts to select your preferred cloud storage service (iCloud or Google Drive).

## What's Included

- **Brewfile**: Contains all the Homebrew formulae, casks, and VS Code extensions to install
- **install.sh**: Main installation script
- **setup_dotfiles.sh**: Script to manage dotfiles across multiple machines via cloud storage
- **utils/**: Helper utilities for the scripts

## Customization

Edit the `Brewfile` to add or remove packages, applications, and VS Code extensions according to your preferences.

## License

MIT [License](./LICENSE)
Copyright (c) 2025 Mike Bohman
