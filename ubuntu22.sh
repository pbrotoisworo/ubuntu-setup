#!/bin/bash

# Ubuntu 22 Setup Script
# Basic commands to update apt and prepare system

set -e  # Exit on any error

echo "Starting Ubuntu 22.x setup..."

# Update package list
echo "Updating package list..."
sudo apt update

# Ask user which Python versions to install
echo ""
echo "Which Python versions would you like to install? (e.g., 3.11,3.12 or leave blank to skip)"
read -p "Enter Python versions separated by commas: " python_versions

# Skip if input is blank
if [[ -z "$python_versions" ]]; then
    echo "Skipping Python installation..."
else
    # Add deadsnakes PPA for Python versions
    echo "Adding deadsnakes PPA..."
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    
    # Update package list after adding PPA
    sudo apt update
    
    # Convert comma-separated input to array
    IFS=',' read -ra VERSIONS <<< "$python_versions"
    
    # Install each requested Python version
    for version in "${VERSIONS[@]}"; do
        # Remove any whitespace
        version=$(echo "$version" | tr -d ' ')
        
        if [[ "$version" == "3.11" ]]; then
            echo "Installing Python 3.11..."
            sudo apt install python3.11 python3.11-venv python3.11-dev -y
        elif [[ "$version" == "3.12" ]]; then
            echo "Installing Python 3.12..."
            sudo apt install python3.12 python3.12-venv python3.12-dev -y
        else
            echo "Warning: Python version '$version' not supported. Skipping..."
        fi
    done
fi

# Upgrade existing packages
echo "Upgrading existing packages..."
sudo apt upgrade -y

# Update package database
echo "Updating package database..."
sudo apt update

echo "Setup complete."