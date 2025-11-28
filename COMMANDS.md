# Useful NixOS Commands Reference

## 🔧 System Management

### Rebuild System
```bash
# Switch to new configuration (home PC)
sudo nixos-rebuild switch --flake /etc/nixos#home

# Switch to new configuration (work PC)
sudo nixos-rebuild switch --flake /etc/nixos#work

# Test configuration without switching
sudo nixos-rebuild test --flake /etc/nixos#home

# Build without activating
sudo nixos-rebuild build --flake /etc/nixos#home

# Build and test in VM
sudo nixos-rebuild build-vm --flake /etc/nixos#home
./result/bin/run-nixos-vm
```

### Update System
```bash
# Update flake inputs (get latest packages)
cd /etc/nixos
sudo nix flake update

# Update specific input
sudo nix flake lock --update-input omarchy-nix

# Apply updates
sudo nixos-rebuild switch --flake .#home
```

### Rollback
```bash
# List all generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Switch to specific generation
sudo nix-env --switch-generation 42 --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

## 🧹 Cleanup

### Garbage Collection
```bash
# Delete old generations and clean store
sudo nix-collect-garbage -d

# Delete generations older than 30 days
sudo nix-collect-garbage --delete-older-than 30d

# Optimize store (deduplicate)
sudo nix-store --optimize

# Check store size
du -sh /nix/store
```

## 📦 Package Management

### Search Packages
```bash
# Search in nixpkgs
nix search nixpkgs firefox

# Search with more details
nix search nixpkgs --json firefox | jq

# Search on the web
# https://search.nixos.org/packages
```

### Install Temporary Package
```bash
# Install package temporarily (not in config)
nix-shell -p firefox

# Run package without installing
nix run nixpkgs#firefox
```

### Check Package Info
```bash
# Show package details
nix eval nixpkgs#firefox.meta.description

# Show package version
nix eval nixpkgs#firefox.version
```

## 🔍 Debugging

### Check Configuration
```bash
# Validate flake
nix flake check /etc/nixos

# Show flake info
nix flake show /etc/nixos

# Show flake metadata
nix flake metadata /etc/nixos

# Evaluate configuration
nixos-rebuild build --flake /etc/nixos#home --show-trace
```

### View Logs
```bash
# System logs
journalctl -xe

# Boot logs
journalctl -b

# Specific service logs
journalctl -u display-manager
journalctl -u NetworkManager

# Follow logs in real-time
journalctl -f
```

### Hardware Info
```bash
# Show hardware configuration
nixos-generate-config --show-hardware-config

# List PCI devices
lspci

# List USB devices
lsusb

# Check disk info
lsblk
sudo fdisk -l
```

## 🔐 LUKS/Encryption

### Find LUKS UUID
```bash
# Show all UUIDs
ls -l /dev/disk/by-uuid/

# Show LUKS devices
sudo blkid | grep crypto_LUKS

# Check LUKS status
sudo cryptsetup status /dev/mapper/luks-*
```

## 🌐 Network

### Network Management
```bash
# List connections
nmcli connection show

# Connect to WiFi
nmcli device wifi connect "SSID" password "PASSWORD"

# Show network status
nmcli general status

# Restart NetworkManager
sudo systemctl restart NetworkManager
```

## 🎨 Hyprland

### Hyprland Commands
```bash
# Reload Hyprland config
hyprctl reload

# List windows
hyprctl clients

# List workspaces
hyprctl workspaces

# Show active window
hyprctl activewindow

# Kill Hyprland
hyprctl dispatch exit
```

## 📝 Git Operations

### Manage Configuration
```bash
# Check status
cd /etc/nixos
sudo git status

# Commit changes
sudo git add -A
sudo git commit -m "Update configuration"

# Push to remote
sudo git push

# Pull from remote
sudo git pull

# View history
sudo git log --oneline
```

## 🔄 Flake Operations

### Flake Management
```bash
# Update all inputs
sudo nix flake update

# Update specific input
sudo nix flake lock --update-input nixpkgs

# Show flake outputs
nix flake show

# Check flake
nix flake check

# Archive flake
nix flake archive
```

## 🏠 Home Manager

### Home Manager Commands
```bash
# Rebuild home configuration
home-manager switch --flake /etc/nixos#julian@home

# List generations
home-manager generations

# Remove old generations
home-manager expire-generations "-30 days"
```

## 🛠️ Development

### Nix Shell
```bash
# Enter development shell
nix develop

# Run command in shell
nix develop -c bash

# Shell with specific packages
nix-shell -p nodejs python3 gcc
```

### Build Packages
```bash
# Build a package
nix build nixpkgs#firefox

# Build and run
nix run nixpkgs#firefox

# Build from local flake
nix build .#packageName
```

## 📊 System Information

### Show System Info
```bash
# NixOS version
nixos-version

# Nix version
nix --version

# System info
uname -a

# Disk usage
df -h

# Memory usage
free -h

# CPU info
lscpu
```

## 🔧 Services

### Systemd Services
```bash
# List all services
systemctl list-units --type=service

# Start service
sudo systemctl start service-name

# Stop service
sudo systemctl stop service-name

# Restart service
sudo systemctl restart service-name

# Enable service at boot
sudo systemctl enable service-name

# Check service status
systemctl status service-name
```

## 📚 Help

### Get Help
```bash
# NixOS manual
man configuration.nix

# Nix manual
man nix

# Package options
man home-configuration.nix

# Search options
nixos-option services.xserver.enable
```

---

**Pro Tip**: Bookmark this file for quick reference! 📖
