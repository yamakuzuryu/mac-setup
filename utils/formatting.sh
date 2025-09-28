#!/bin/bash

# Text formatting
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
RESET="\033[0m"

# Print colored message
print_message() {
	echo -e "${2}${BOLD}$1${RESET}"
}
