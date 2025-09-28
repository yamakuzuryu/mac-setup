#!/bin/bash

# Workflow
## Make script executable `chmod +x setup_dotfiles.sh`
## Run script `./setup_dotfiles.sh`
## Choose between iCloud or Google Drive for storing dotfiles
## First Run: The script will detect no files in the selected cloud service and copy your dotfiles there
## Subsequent Runs on Same Computer: The script will skip files already set up
## Running on New Computer: The script will detect files in the cloud service and create symlinks
## Adding New Dotfiles: Add to the DOTFILES array and run again - only new files will be processed

# Configuration
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
BACKUP_CREATED=false
SELECTED_CLOUD=""

# Cloud service paths
GOOGLE_DRIVE_PATH="$HOME/Google Drive/My Drive"
ICLOUD_DRIVE_PATH="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

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

# Create backup directory if needed
create_backup_dir_if_needed() {
	if [ "$BACKUP_CREATED" = false ]; then
		mkdir -p "$BACKUP_DIR"
		BACKUP_CREATED=true
		print_message "Created backup directory at $BACKUP_DIR" "$GREEN"
	fi
}

# Function to select cloud service
select_cloud_service() {
	print_message "Select cloud service for storing dotfiles:" "$CYAN"
	echo -e "  ${BOLD}1${RESET}. iCloud Drive"
	echo -e "  ${BOLD}2${RESET}. Google Drive"
	
	while true; do
		read -p "Enter your choice (1-2): " choice
		case $choice in
			1)
				if [ ! -d "$ICLOUD_DRIVE_PATH" ]; then
					print_message "Error: iCloud Drive folder not found at $ICLOUD_DRIVE_PATH" "$RED"
					print_message "Please ensure iCloud Drive is set up properly on your Mac." "$YELLOW"
					exit 1
				fi
				SELECTED_CLOUD="iCloud"
				DOTFILES_DIR="$ICLOUD_DRIVE_PATH/Dotfiles"
				break
				;;
			2)
				if [ ! -d "$GOOGLE_DRIVE_PATH" ]; then
					print_message "Error: Google Drive folder not found at $GOOGLE_DRIVE_PATH" "$RED"
					print_message "Please install Google Drive for Desktop and ensure it's syncing properly." "$YELLOW"
					exit 1
				fi
				SELECTED_CLOUD="Google Drive"
				DOTFILES_DIR="$GOOGLE_DRIVE_PATH/Dotfiles"
				break
				;;
			*)
				print_message "Invalid selection. Please enter 1 or 2." "$RED"
				;;
		esac
	done
	
	print_message "Selected $SELECTED_CLOUD for dotfiles storage." "$GREEN"
}

# Run the selection process
select_cloud_service

# Create dotfiles directory in selected cloud service if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
	print_message "Creating dotfiles directory in $SELECTED_CLOUD..." "$GREEN"
	mkdir -p "$DOTFILES_DIR"
	print_message "This appears to be your first time running this script." "$CYAN"
	print_message "Will set up your dotfiles in $SELECTED_CLOUD." "$CYAN"
fi

# List of dotfiles to manage
DOTFILES=(
	".gitconfig"
	#".gitconfig-work"
	".gitignore"
	# ".ssh/config"
	".zshrc"
	".zshrc-alias"
	".zshrc-ohmyzsh"
	# ".zshrc-private"
)

# Track what we've done
ADDED_COUNT=0
LINKED_COUNT=0
SKIPPED_COUNT=0

# Process each dotfile
for dotfile in "${DOTFILES[@]}"; do
	# Skip commented out entries
	if [[ "$dotfile" == \#* ]]; then
		continue
	fi

	# Get the directory part of the path
	dir_path=$(dirname "$dotfile")
	file_name=$(basename "$dotfile")
	target_dir="$DOTFILES_DIR/$dir_path"
	target_file="$target_dir/${file_name#.}"  # Remove the dot for storage
	source_file="$HOME/$dotfile"

	# Check if file exists in cloud storage
	FILE_IN_CLOUD=false
	if [ -f "$target_file" ]; then
		FILE_IN_CLOUD=true
	fi

	# Check if proper symlink exists
	SYMLINK_EXISTS=false
	if [ -L "$source_file" ] && [ "$(readlink "$source_file")" = "$target_file" ]; then
		SYMLINK_EXISTS=true
	fi

	# Case 1: File exists in cloud storage and symlink is correct - skip
	if [ "$FILE_IN_CLOUD" = true ] && [ "$SYMLINK_EXISTS" = true ]; then
		print_message "Skipping $dotfile (already set up correctly)" "$BLUE"
		SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
		continue
	fi

	# Case 2: File exists locally but not in cloud storage - add to cloud storage
	if [ ! "$FILE_IN_CLOUD" = true ] && [ -f "$source_file" ]; then
		# Create backup directory if this is our first backup
		create_backup_dir_if_needed

		# Create target directory if needed
		if [ "$dir_path" != "." ]; then
			mkdir -p "$target_dir"
			mkdir -p "$BACKUP_DIR/$dir_path"
		fi

		# Backup existing file
		cp -L "$source_file" "$BACKUP_DIR/$dotfile"
		print_message "Backed up $dotfile" "$GREEN"

		# Copy file to cloud storage
		cp "$source_file" "$target_file"
		print_message "Added $dotfile to $SELECTED_CLOUD" "$GREEN"
		ADDED_COUNT=$((ADDED_COUNT + 1))

		# Remove original file (will create symlink below)
		rm "$source_file"

		# Now the file exists in cloud storage
		FILE_IN_CLOUD=true
	fi

	# Case 3: File exists in cloud storage but symlink is missing or incorrect
	if [ "$FILE_IN_CLOUD" = true ] && [ ! "$SYMLINK_EXISTS" = true ]; then
		# Create target directory if needed
		if [ "$dir_path" != "." ] && [ ! -d "$HOME/$dir_path" ]; then
			mkdir -p "$HOME/$dir_path"
		fi

		# Backup existing file if it exists and is not a symlink
		if [ -f "$source_file" ] && [ ! -L "$source_file" ]; then
			backup_file="${source_file}.backup.$(date +%Y%m%d_%H%M%S)"
			mv "$source_file" "$backup_file"
			print_message "Backed up existing $dotfile to ${backup_file}" "$YELLOW"
		elif [ -L "$source_file" ]; then
			# Remove incorrect symlink
			rm "$source_file"
		fi

		# Create symlink
		ln -s "$target_file" "$source_file"
		print_message "Created symlink for $dotfile" "$GREEN"
		LINKED_COUNT=$((LINKED_COUNT + 1))
	fi

	# Case 4: File doesn't exist locally or in cloud storage - skip
	if [ ! "$FILE_IN_CLOUD" = true ] && [ ! -f "$source_file" ]; then
		print_message "Skipping $dotfile (not found locally or in $SELECTED_CLOUD)" "$YELLOW"
		SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
	fi
done

# Create a restore script in the backup directory if we created backups
if [ "$BACKUP_CREATED" = true ]; then
	cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/bin/bash
BACKUP_DIR=$(dirname "$0")
cd "$BACKUP_DIR" || exit 1
for file in $(find . -type f -not -name "restore.sh"); do
	target="$HOME/${file#./}"
	target_dir=$(dirname "$target")
	mkdir -p "$target_dir"
	cp "$file" "$target"
	echo "Restored $target"
done
echo "All files restored!"
EOF

	chmod +x "$BACKUP_DIR/restore.sh"
	print_message "Created restore script at $BACKUP_DIR/restore.sh" "$GREEN"
fi

# Print summary
print_message "\nSummary:" "$CYAN"
print_message "  • Added to $SELECTED_CLOUD: $ADDED_COUNT files" "$CYAN"
print_message "  • Created symlinks: $LINKED_COUNT files" "$CYAN"
print_message "  • Skipped: $SKIPPED_COUNT files" "$CYAN"

if [ "$BACKUP_CREATED" = true ]; then
	print_message "\nBackup of original files saved to $BACKUP_DIR" "$GREEN"
	print_message "If you need to restore the original files, run the restore script in the backup directory." "$YELLOW"
fi

print_message "\nSetup complete! Your dotfiles are now managed through $SELECTED_CLOUD." "$GREEN"
print_message "To add new dotfiles, simply add them to the DOTFILES array in this script and run it again." "$YELLOW"
