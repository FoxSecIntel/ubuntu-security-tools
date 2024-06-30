#!/bin/bash

# Script to list installed software and their versions on an Ubuntu filesystem

# Get the current date
current_date=$(date +%Y-%m-%d)

# Function to list installed packages from apt
list_apt_packages() {
    local output_file="apt_packages_$current_date.txt"
    echo "Listing installed packages from apt..."
    dpkg-query -W -f='${binary:Package} ${Version}\n' > "$output_file"
    echo "Installed packages from apt saved to $output_file"
}

# Function to list installed packages from snap
list_snap_packages() {
    local output_file="snap_packages_$current_date.txt"
    echo "Listing installed packages from snap..."
    snap list | awk 'NR>1 {print $1, $2}' > "$output_file"
    echo "Installed packages from snap saved to $output_file"
}

# Function to list installed pip packages (for Python)
list_pip_packages() {
    local output_file="pip_packages_$current_date.txt"
    echo "Listing installed packages from pip..."
    pip list --format=freeze > "$output_file"
    echo "Installed packages from pip saved to $output_file"
}

# Function to list installed npm packages (for Node.js)
list_npm_packages() {
    local output_file="npm_packages_$current_date.txt"
    echo "Listing globally installed packages from npm..."
    npm list -g --depth=0 | awk -F@ '/@/ {print $1, $2}' > "$output_file"
    echo "Globally installed packages from npm saved to $output_file"
}

# Function to list installed Ruby gems
list_gem_packages() {
    local output_file="gem_packages_$current_date.txt"
    echo "Listing installed Ruby gems..."
    gem list | awk '{print $1, $2}' > "$output_file"
    echo "Installed Ruby gems saved to $output_file"
}

# Function to list software in common directories
list_common_directories() {
    local output_file="common_directories_$current_date.txt"
    echo "Listing software from common directories..."
    echo "/usr/bin:*****************************************************************" > "$output_file"
    ls /usr/bin >> "$output_file"
    echo "/usr/local/bin: **********************************************************" >> "$output_file"
    ls /usr/local/bin >> "$output_file"
    echo "/opt: ********************************************************************" >> "$output_file"
    ls /opt >> "$output_file"
    echo "Software from common directories saved to $output_file"
}

# Main script execution
echo "Select an option to list installed software:"
echo "1. apt packages"
echo "2. snap packages"
echo "3. pip packages"
echo "4. npm packages"
echo "5. Ruby gems"
echo "6. Software in common directories"
echo "7. All of the above"
read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        list_apt_packages
        ;;
    2)
        list_snap_packages
        ;;
    3)
        list_pip_packages
        ;;
    4)
        list_npm_packages
        ;;
    5)
        list_gem_packages
        ;;
    6)
        list_common_directories
        ;;
    7)
        list_apt_packages
        list_snap_packages
        list_pip_packages
        list_npm_packages
        list_gem_packages
        list_common_directories
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo "Software listing complete."
