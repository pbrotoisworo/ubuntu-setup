#!/bin/bash

# Ubuntu 22 Setup Script
# Basic commands to update apt and prepare system

# Initialize tracking arrays
installed_successfully=()
failed_installs=()

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
    if sudo add-apt-repository ppa:deadsnakes/ppa -y; then
        installed_successfully+=("deadsnakes PPA")
    else
        failed_installs+=("deadsnakes PPA")
    fi
    
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
            if sudo apt install python3.11 python3.11-venv python3.11-dev -y; then
                installed_successfully+=("Python 3.11")
            else
                failed_installs+=("Python 3.11")
            fi
        elif [[ "$version" == "3.12" ]]; then
            echo "Installing Python 3.12..."
            if sudo apt install python3.12 python3.12-venv python3.12-dev -y; then
                installed_successfully+=("Python 3.12")
            else
                failed_installs+=("Python 3.12")
            fi
        else
            echo "Warning: Python version '$version' not supported. Skipping..."
            failed_installs+=("Python $version (unsupported)")
        fi
    done
fi

# Upgrade existing packages
echo "Upgrading existing packages..."
if sudo apt upgrade -y; then
    installed_successfully+=("Package upgrades")
else
    failed_installs+=("Package upgrades")
fi

# Update package database
echo "Updating package database..."
sudo apt update

# Print installation summary
echo ""
echo "=== INSTALLATION SUMMARY ==="
echo ""

if [ ${#installed_successfully[@]} -gt 0 ]; then
    echo "✅ Successfully installed/completed:"
    for item in "${installed_successfully[@]}"; do
        echo "   - $item"
    done
    echo ""
fi

if [ ${#failed_installs[@]} -gt 0 ]; then
    echo "❌ Failed installations:"
    for item in "${failed_installs[@]}"; do
        echo "   - $item"
    done
    echo ""
fi

if [ ${#failed_installs[@]} -eq 0 ]; then
    echo "🎉 All installations completed successfully!"
else
    echo "⚠️  Some installations failed. Check the output above for details."
fi

echo ""
echo "Setup complete."