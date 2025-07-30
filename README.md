# ubuntu-setup
Commands and scripts to setup an Ubuntu environment for development and other basic tools

## Usage

### Ubuntu 22.x Setup Script

Run the Ubuntu 22.x setup script:

```bash
./ubuntu22.sh
```

Or with explicit bash:

```bash
bash ubuntu22.sh
```

**Note**: Make sure the script is executable. If not, run:
```bash
chmod +x ubuntu22.sh
```

### What the script does:
- Updates apt package lists
- Prompts for Python versions to install (3.11, 3.12, or both)
- Adds deadsnakes PPA if Python versions are requested
- Installs selected Python versions with venv and dev packages
- Upgrades existing packages
