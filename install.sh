#!/usr/bin/env bash
set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/JulianPasco/omarchy-nixos"
INSTALL_DIR="/etc/nixos"

echo -e "${BLUE}"
cat << "EOF"
   ___                       _           
  / _ \ _ __ ___   __ _ _ __(_)_  ___   _
 | | | | '_ ` _ \ / _` | '__| \ \/ / | | |
 | |_| | | | | | | (_| | |  | |>  <| |_| |
  \___/|_| |_| |_|\__,_|_|  |_/_/\_\\__, |
                                    |___/ 
  NixOS Installation Script
EOF
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo -e "${RED}❌ Please do not run this script as root${NC}"
   echo "Run it as your normal user, it will use sudo when needed"
   exit 1
fi

# Check if running on NixOS
if [ ! -f /etc/NIXOS ]; then
    echo -e "${RED}❌ This script must be run on NixOS${NC}"
    echo "Please install NixOS first: https://nixos.org/download.html"
    exit 1
fi

# Check if git is available
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}📦 Installing git...${NC}"
    sudo nix-env -iA nixos.git
fi

echo -e "${GREEN}🚀 Starting Omarchy NixOS installation${NC}"
echo ""

# Prompt for user information
echo -e "${BLUE}Let's set up your system${NC}"
echo ""

while [ -z "${USER_FULLNAME:-}" ]; do
    read -p "Enter your full name: " USER_FULLNAME
    if [ -z "$USER_FULLNAME" ]; then
        echo -e "${RED}Name cannot be empty${NC}"
    fi
done

while [ -z "${USER_EMAIL:-}" ]; do
    read -p "Enter your email address: " USER_EMAIL
    if [ -z "$USER_EMAIL" ]; then
        echo -e "${RED}Email cannot be empty${NC}"
    fi
done

while [ -z "${USER_NAME:-}" ]; do
    read -p "Enter your username: " USER_NAME
    if [ -z "$USER_NAME" ]; then
        echo -e "${RED}Username cannot be empty${NC}"
    fi
done

echo ""

# Prompt for hostname with validation loop
while true; do
    echo -e "${BLUE}Which machine is this?${NC}"
    echo "1) home"
    echo "2) work"
    read -p "Enter choice (1 or 2): " choice
    
    case $choice in
        1)
            HOSTNAME="home"
            break
            ;;
        2)
            HOSTNAME="work"
            break
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Please enter 1 or 2.${NC}"
            echo ""
            ;;
    esac
done

echo -e "${GREEN}✓ Selected: $HOSTNAME${NC}"
echo ""

# Backup existing configuration
if [ -d "$INSTALL_DIR" ]; then
    BACKUP_DIR="${INSTALL_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}📦 Backing up existing configuration to $BACKUP_DIR${NC}"
    sudo mv "$INSTALL_DIR" "$BACKUP_DIR"
fi

# Clone repository
echo -e "${YELLOW}📥 Cloning configuration from $REPO_URL${NC}"
sudo git clone "$REPO_URL" "$INSTALL_DIR"

# Generate hardware configuration
echo -e "${YELLOW}🔧 Generating hardware configuration...${NC}"
sudo nixos-generate-config --show-hardware-config | sudo tee "$INSTALL_DIR/hosts/hardware-$HOSTNAME.nix" > /dev/null

# Update flake.nix with user information
echo -e "${YELLOW}📝 Configuring user settings...${NC}"
sudo sed -i "s/full_name = \".*\";/full_name = \"$USER_FULLNAME\";/" "$INSTALL_DIR/flake.nix"
sudo sed -i "s/email_address = \".*\";/email_address = \"$USER_EMAIL\";/" "$INSTALL_DIR/flake.nix"

# Update host files with username
sudo sed -i "s/users.users.julian/users.users.$USER_NAME/g" "$INSTALL_DIR/hosts/$HOSTNAME.nix"
sudo sed -i "s/home.username = \"julian\";/home.username = \"$USER_NAME\";/" "$INSTALL_DIR/flake.nix"
sudo sed -i "s|home.homeDirectory = \"/home/julian\";|home.homeDirectory = \"/home/$USER_NAME\";|" "$INSTALL_DIR/flake.nix"
sudo sed -i "s/users.julian/users.$USER_NAME/g" "$INSTALL_DIR/flake.nix"

# Check for LUKS encryption
if ls /dev/mapper/luks-* 2>/dev/null 1>&2; then
    echo -e "${YELLOW}🔐 LUKS encryption detected${NC}"
    
    LUKS_UUID=$(sudo blkid -s UUID -o value $(sudo cryptsetup status $(ls /dev/mapper/luks-* | head -1 | xargs basename) | grep device | awk '{print $2}'))
    
    if [ -n "$LUKS_UUID" ]; then
        echo -e "${GREEN}✓ Found LUKS UUID: $LUKS_UUID${NC}"
        
        # Add LUKS configuration to host file
        sudo sed -i "s|# boot.initrd.luks.devices.\"luks-root\".device = \"/dev/disk/by-uuid/YOUR-UUID-HERE\";|boot.initrd.luks.devices.\"luks-root\".device = \"/dev/disk/by-uuid/$LUKS_UUID\";|" "$INSTALL_DIR/hosts/$HOSTNAME.nix"
        echo -e "${GREEN}✓ LUKS configuration added${NC}"
    fi
fi

# Initialize git in the config directory
echo -e "${YELLOW}📝 Initializing git repository${NC}"
cd "$INSTALL_DIR"
sudo git config --global --add safe.directory "$INSTALL_DIR"

# Build and switch to new configuration
echo -e "${YELLOW}🏗️  Building system configuration (this may take a while)...${NC}"
echo -e "${BLUE}This will download and build all packages needed for Omarchy${NC}"
echo ""

if sudo nixos-rebuild switch --flake "$INSTALL_DIR#$HOSTNAME"; then
    echo ""
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo -e "${BLUE}📋 Next steps:${NC}"
    echo "1. Change your password: passwd"
    echo "2. Log out of your current session"
    echo "3. At the login screen, select 'Hyprland' as your session"
    echo "4. Log in and enjoy your Omarchy setup!"
    echo ""
    echo -e "${YELLOW}💡 Useful commands:${NC}"
    echo "  • Update system: sudo nixos-rebuild switch --flake /etc/nixos#$HOSTNAME"
    echo "  • Edit config: sudo nano /etc/nixos/hosts/$HOSTNAME.nix"
    echo "  • Update flake: cd /etc/nixos && sudo nix flake update"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Installation failed${NC}"
    echo "Check the error messages above for details"
    exit 1
fi
