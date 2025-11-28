# Complete Setup Guide

This guide walks you through setting up your Omarchy-style NixOS system from scratch.

## 📋 Pre-Installation Checklist

- [ ] Downloaded NixOS ISO (24.05 or newer)
- [ ] Created bootable USB drive
- [ ] Backed up important data
- [ ] Have stable internet connection
- [ ] Know your WiFi password (if applicable)

## 🚀 Part 1: Install NixOS

### Step 1: Boot from USB

1. Insert USB drive
2. Restart computer
3. Enter BIOS/UEFI (usually F2, F12, Del, or Esc)
4. Select USB drive as boot device
5. Choose "NixOS Installer" from boot menu

### Step 2: Connect to Internet

**For Ethernet**: Should work automatically

**For WiFi**:
```bash
# List available networks
nmcli device wifi list

# Connect to network
nmcli device wifi connect "YOUR-SSID" password "YOUR-PASSWORD"

# Verify connection
ping -c 3 google.com
```

### Step 3: Partition Disks

**Option A: Graphical Installer (Recommended for beginners)**

1. Type `sudo systemctl start display-manager`
2. Use the graphical installer
3. Choose "Erase disk and install NixOS"
4. Enable encryption (recommended)
5. Set up user account
6. Complete installation

**Option B: Manual Partitioning**

For UEFI with encryption:

```bash
# Find your disk (usually /dev/nvme0n1 or /dev/sda)
lsblk

# Set disk variable (CHANGE THIS!)
DISK=/dev/nvme0n1

# Create partitions
sudo parted $DISK -- mklabel gpt
sudo parted $DISK -- mkpart ESP fat32 1MiB 512MiB
sudo parted $DISK -- set 1 esp on
sudo parted $DISK -- mkpart primary 512MiB 100%

# Setup LUKS encryption
sudo cryptsetup luksFormat ${DISK}p2
sudo cryptsetup luksOpen ${DISK}p2 cryptroot

# Format partitions
sudo mkfs.fat -F 32 -n boot ${DISK}p1
sudo mkfs.ext4 -L nixos /dev/mapper/cryptroot

# Mount filesystems
sudo mount /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/boot
sudo mount ${DISK}p1 /mnt/boot

# Generate initial config
sudo nixos-generate-config --root /mnt

# Install minimal system
sudo nixos-install
```

### Step 4: Complete Installation

1. Set root password when prompted
2. Reboot: `sudo reboot`
3. Remove USB drive
4. Boot into new NixOS system

## 🎨 Part 2: Install Omarchy Configuration

### Step 1: Log In

1. Boot into NixOS
2. Log in with the user you created
3. Open a terminal (if in graphical environment)

### Step 2: Run Installer

```bash
curl -fsSL https://raw.githubusercontent.com/JulianPasco/omarchy-nixos/main/install.sh | bash
```

### Step 3: Select Configuration

When prompted, choose:
- `1` for home PC
- `2` for work PC

### Step 4: Wait for Installation

The installer will:
- Clone the configuration
- Detect your hardware
- Download all packages
- Build the system
- Activate Hyprland

**This may take 15-30 minutes depending on your internet speed.**

### Step 5: First Login

1. Log out: `logout` or close session
2. At login screen, click the session selector (usually top-right)
3. Select "Hyprland"
4. Log in with your password

## 🎉 Part 3: First Steps in Hyprland

### Welcome to Hyprland!

You should now see:
- Beautiful wallpaper
- Status bar at the top (Waybar)
- Dock at the bottom (nwg-dock-hyprland)

### Essential Keybindings

Try these out:

1. **Open Terminal**: `Super + Return`
2. **Open Launcher**: `Super + D`
3. **Open Browser**: `Super + B`
4. **Close Window**: `Super + Q`

### Change Your Password

```bash
passwd
```

### Test Your Setup

```bash
# Check system info
neofetch

# Or use fastfetch
fastfetch

# Test terminal
alacritty

# Test editor
nvim
```

## 🔧 Part 4: Customization

### Update Your Information

Edit the configuration:

```bash
sudo nano /etc/nixos/flake.nix
```

Find and update:
```nix
omarchy = {
  full_name = "Your Name";        # Change this
  email_address = "your@email";   # Change this
  theme = "tokyo-night";          # Change if desired
};
```

Save and rebuild:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

### Add More Software

Edit `/etc/nixos/flake.nix` and add to `home.packages`:

```nix
home.packages = with pkgs; [
  google-chrome
  onlyoffice-desktopeditors
  windsurf
  nwg-dock-hyprland
  
  # Add your packages here
  slack
  discord
  spotify
  gimp
  vlc
];
```

Rebuild:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

### Configure Git

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

## 🔄 Part 5: Syncing Between Machines

### On First Machine (Home)

1. Create GitHub repository:
   ```bash
   # On GitHub, create a new repository called "nixos-config"
   ```

2. Push your configuration:
   ```bash
   cd /etc/nixos
   sudo git remote add origin https://github.com/yourusername/nixos-config.git
   sudo git add -A
   sudo git commit -m "Initial configuration"
   sudo git push -u origin main
   ```

### On Second Machine (Work)

1. Install NixOS (Part 1)

2. Clone your configuration:
   ```bash
   # Instead of using the curl installer, clone your repo
   sudo rm -rf /etc/nixos
   sudo git clone https://github.com/yourusername/nixos-config.git /etc/nixos
   ```

3. Generate hardware config:
   ```bash
   sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix
   sudo mv /tmp/hardware.nix /etc/nixos/hosts/hardware-work.nix
   ```

4. Build and switch:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#work
   ```

### Making Changes

On any machine:

1. Edit configuration
2. Test: `sudo nixos-rebuild switch --flake /etc/nixos#home`
3. Commit: `sudo git add -A && sudo git commit -m "Update"`
4. Push: `sudo git push`

On other machine:

1. Pull: `cd /etc/nixos && sudo git pull`
2. Apply: `sudo nixos-rebuild switch --flake /etc/nixos#work`

## 🎯 Part 6: Learning Hyprland

### Window Management

- `Super + Q`: Close window
- `Super + Space`: Toggle floating
- `Super + F`: Fullscreen
- `Super + H/J/K/L`: Move focus (Vim-style)
- `Super + Shift + H/J/K/L`: Move window

### Workspaces

- `Super + 1-9`: Switch to workspace
- `Super + Shift + 1-9`: Move window to workspace
- `Super + Mouse Wheel`: Cycle workspaces

### Applications

- `Super + Return`: Terminal
- `Super + B`: Browser
- `Super + D`: Launcher
- `Super + E`: File Manager
- `Super + N`: Neovim

### System

- `Super + L`: Lock screen
- `Super + Shift + E`: Exit menu
- `Print`: Screenshot region
- `Shift + Print`: Screenshot full screen

## 📚 Part 7: Next Steps

### Learn NixOS

1. Read [NixOS Manual](https://nixos.org/manual/nixos/stable/)
2. Explore [NixOS Wiki](https://nixos.wiki/)
3. Join [NixOS Discourse](https://discourse.nixos.org/)

### Customize Further

1. Explore themes in `/etc/nixos/flake.nix`
2. Add more packages
3. Customize Hyprland keybindings
4. Set up development environments

### Backup Strategy

1. Keep configuration in Git
2. Regular commits: `cd /etc/nixos && sudo git add -A && sudo git commit -m "Update"`
3. Push to GitHub: `sudo git push`
4. Your system is now reproducible!

## 🆘 Troubleshooting

If something goes wrong, see:
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues
- [HARDWARE-DETECTION.md](HARDWARE-DETECTION.md) - Hardware setup
- [COMMANDS.md](COMMANDS.md) - Useful commands

### Quick Fixes

**System won't boot**: Boot from USB and rollback
```bash
sudo nixos-rebuild switch --rollback
```

**Hyprland won't start**: Check logs
```bash
journalctl -u display-manager -b
```

**Build fails**: Check syntax
```bash
nix flake check /etc/nixos
```

## ✅ Checklist

After setup, verify:

- [ ] Can log into Hyprland
- [ ] Terminal opens (Super + Return)
- [ ] Browser works (Super + B)
- [ ] WiFi/Ethernet connected
- [ ] Audio works
- [ ] Changed default password
- [ ] Git configured
- [ ] Configuration backed up to GitHub

## 🎊 You're Done!

Congratulations! You now have a beautiful, declarative NixOS system with Omarchy-style Hyprland.

**Enjoy your new setup!** 🚀

---

**Pro Tips**:
- Take snapshots before major changes
- Keep your configuration in Git
- Experiment - you can always rollback!
- Join the NixOS community for help
