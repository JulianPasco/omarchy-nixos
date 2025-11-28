# Omarchy NixOS Configuration

A NixOS port of the Omarchy desktop environment, providing a beautiful Hyprland-based setup with full feature parity.

## ⚠️ Important Notes

**Hardware Configuration Files:**
- `hosts/hardware-work.nix` and `hosts/hardware-home.nix` are **PLACEHOLDER** files
- They will be **automatically replaced** during installation by `nixos-generate-config`
- The install script detects your actual hardware (disks, LUKS, CPU, etc.)
- **Do NOT commit your actual hardware config** to the repo (it's machine-specific)

**Themes:**
- ✨ **14 Omarchy themes included** - See [THEMES.md](THEMES.md) for details
- 🎨 Switch themes via **Super + Alt + Space** → Type "themes"
- 🔧 Default theme: Tokyo Night (change in `flake.nix` or via menu)

## ✨ Features

- **🎨 Beautiful Hyprland Setup**: Same look, feel, and keybindings as Omarchy
- **📦 Declarative Configuration**: Everything as code - reproducible across machines
- **🔄 Easy Sync**: Same configuration for home and work PCs
- **⚡ One-Command Install**: Simple curl-based installation
- **🛠️ Development Ready**: Pre-configured with modern development tools
- **🎯 Based on omarchy-nix**: Uses [omarchy-nix](https://github.com/henrysipp/omarchy-nix) flake for Hyprland configuration
- **📝 Customizable**: Easy to add more packages and modify configuration

## 🚀 Quick Installation

On a fresh NixOS installation, run:

```bash
# Download the installer (with cache bypass)
curl -fsSL "https://raw.githubusercontent.com/JulianPasco/omarchy-nixos/main/install.sh?$(date +%s)" -o install.sh

# Make it executable
chmod +x install.sh

# Run it
./install.sh
```

**Or as a one-liner:**
```bash
curl -fsSL "https://raw.githubusercontent.com/JulianPasco/omarchy-nixos/main/install.sh?$(date +%s)" -o install.sh && chmod +x install.sh && ./install.sh
```

**⚠️ Important:** Never use `curl | bash` for this script - it won't work because the script needs interactive input!

The installer will:
1. Prompt you to select home or work configuration
2. Clone this repository to `/etc/nixos`
3. Auto-detect your hardware configuration
4. Build and activate your new system
5. Set up Hyprland with all Omarchy defaults

**That's it!** Just log out and select Hyprland at the login screen.

## 📋 Prerequisites

- Fresh NixOS installation (24.05 or newer)
- UEFI system (for systemd-boot)
- 8GB RAM minimum (16GB+ recommended)
- 40GB disk space
- Internet connection

## 🎮 What You Get

### From omarchy-nix
- **Terminal**: Ghostty (with Alacritty fallback)
- **Editor**: Neovim
- **File Manager**: Nautilus
- **Launcher**: Wofi
- **Status Bar**: Waybar
- **Notifications**: Mako
- **Screenshots**: Hyprshot
- **Browser**: Chromium
- **Development Tools**: lazygit, lazydocker, btop, gh

### Additional Packages (Customizable)
- **Office**: OnlyOffice Desktop Editors
- **Development**: Windsurf IDE
- **Browser**: Google Chrome
- **Dock**: nwg-dock-hyprland
- **And more**: Easy to add via flake.nix

### Hyprland Configuration
- **Theme**: Tokyo Night (default)
- **Animations**: Smooth and modern
- **Tiling**: Dynamic with smart gaps
- **Touchpad**: Natural scrolling enabled
- **Keybindings**: Same as Omarchy

### Key Bindings (Omarchy-compatible)

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + B` | Browser |
| `Super + F` | File Manager |
| `Super + D` | Launcher |
| `Super + Q` | Close Window |
| `Super + Space` | Toggle Floating |
| `Super + 1-9` | Switch Workspace |
| `Super + Shift + 1-9` | Move to Workspace |
| `Print` | Screenshot |
| `Super + L` | Lock Screen |

## 📁 Project Structure

```
nixos/
├── flake.nix              # Main flake configuration
├── flake.lock             # Locked dependencies
├── install.sh             # Bootstrap installation script
├── hosts/
│   ├── home.nix           # Home PC configuration
│   ├── hardware-home.nix  # Auto-generated hardware config (home)
│   └── hardware-work.nix  # Auto-generated hardware config (work)
└── README.md              # This file
```
### Manual Installation

If you prefer manual installation or want to customize before installing:

### 1. Clone the Repository

```bash
git clone https://github.com/JulianPasco/omarchy-nixos
cd omarchy-nixos
```

### 2. Generate Hardware Configuration

```bash
sudo nixos-generate-config --show-hardware-config > hosts/hardware-$(hostname).nix
```

### 3. Edit Host Configuration

Edit `hosts/home.nix` or `hosts/work.nix`:

```bash
sudo nano hosts/home.nix
```

Update the LUKS UUID if you have encryption:

```bash
# Find your LUKS UUID
ls -l /dev/disk/by-uuid/

# Add to your host file:
boot.initrd.luks.devices."luks-root".device = "/dev/disk/by-uuid/YOUR-UUID-HERE";
```

### 4. Copy to /etc/nixos

```bash
sudo cp -r . /etc/nixos/
cd /etc/nixos
```

### 5. Build and Switch

```bash
# For home PC
sudo nixos-rebuild switch --flake .#home

# For work PC
sudo nixos-rebuild switch --flake .#work
```

## 🎨 Customization

### Change Theme

Edit `flake.nix` and modify the theme setting:

```nix
omarchy = {
  full_name = "Your Name";
  email_address = "your@email.com";
  theme = "catppuccin";  # Options: tokyo-night, kanagawa, everforest, catppuccin, nord, gruvbox
};
```

Available themes:
- `tokyo-night` (default)
- `kanagawa`
- `everforest`
- `catppuccin`
- `nord`
- `gruvbox`
- `gruvbox-light`

### Add More Packages

Edit `flake.nix` in the `home.packages` section:

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
];
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

### Customize Hyprland

Edit the `wayland.windowManager.hyprland.extraConfig` section in `flake.nix`:

```nix
wayland.windowManager.hyprland = {
  extraConfig = ''
    # Your custom Hyprland config here
    input {
      touchpad {
        natural_scroll = true
      }
    }
    
    # Custom keybindings
    bind = SUPER, T, exec, alacritty
  '';
};
```

## 🔄 Syncing Between Machines

### Initial Setup

1. **On Home PC**: Install using the script, select "home"
2. **On Work PC**: Install using the script, select "work"

### Making Changes

1. Edit configuration on either machine:
   ```bash
   cd /etc/nixos
   sudo nano hosts/home.nix  # or work.nix
   ```

2. Test the changes:
   ```bash
   sudo nixos-rebuild switch --flake .#home
   ```

3. Commit and push:
   ```bash
   sudo git add -A
   sudo git commit -m "Update configuration"
   sudo git push
   ```

4. Pull on the other machine:
   ```bash
   cd /etc/nixos
   sudo git pull
   sudo nixos-rebuild switch --flake .#work
   ```

## 🛠️ Useful Commands

```bash
# Update system
sudo nixos-rebuild switch --flake /etc/nixos#home

# Update flake inputs (get latest omarchy-nix)
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#home

# List generations (for rollback)
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Clean old generations
sudo nix-collect-garbage -d

# Check flake
nix flake check /etc/nixos

# Show flake info
nix flake show /etc/nixos
```

## 🐛 Troubleshooting

### Build Fails

```bash
# Check for syntax errors
nix flake check /etc/nixos

# Try building without switching
sudo nixos-rebuild build --flake /etc/nixos#home
```

### Hyprland Won't Start

1. Check logs:
   ```bash
   journalctl -xe
   ```

2. Try starting manually:
   ```bash
   Hyprland
   ```

### Hardware Not Detected

Regenerate hardware configuration:

```bash
sudo nixos-generate-config --show-hardware-config > /etc/nixos/hosts/hardware-$(hostname).nix
sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)
```

### LUKS Encryption Issues

Find your LUKS UUID:

```bash
sudo blkid | grep crypto_LUKS
```

Add to your host configuration:

```nix
boot.initrd.luks.devices."luks-root".device = "/dev/disk/by-uuid/YOUR-UUID";
```

## 📚 Learning Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Omarchy Documentation](https://github.com/basecamp/omarchy)
- [omarchy-nix Repository](https://github.com/henrysipp/omarchy-nix)

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

MIT License - Same as Omarchy

## 🙏 Acknowledgments

- [Omarchy](https://github.com/basecamp/omarchy) by DHH - The original inspiration
- [omarchy-nix](https://github.com/henrysipp/omarchy-nix) by Henry Sipp - NixOS implementation
- [NixOS](https://nixos.org/) - The declarative Linux distribution
- [Hyprland](https://hyprland.org/) - Dynamic tiling Wayland compositor

---

**Built with ❤️ for the NixOS community**
