# Quick Start Guide

## 🚀 Installation in 3 Steps

### Step 1: Install NixOS

1. Download NixOS ISO from [nixos.org](https://nixos.org/download.html)
2. Create a bootable USB drive
3. Boot from USB and follow the graphical installer
4. Choose your disk partitioning (LUKS encryption recommended)
5. Complete the installation and reboot

### Step 2: Run the Installer

After booting into your fresh NixOS installation:

```bash
curl -fsSL https://raw.githubusercontent.com/JulianPasco/omarchy-nixos/main/install.sh | bash
```

Select either:
- `1` for home PC
- `2` for work PC

The installer will:
- ✅ Clone the configuration
- ✅ Detect your hardware
- ✅ Configure LUKS if present
- ✅ Build and activate the system
- ✅ Install Hyprland with Omarchy setup

### Step 3: Log In

1. Log out of your current session
2. At the login screen, click the session selector
3. Choose **Hyprland**
4. Log in with your password
5. Enjoy your Omarchy-style desktop! 🎉

## ⌨️ Essential Keybindings

| Key | Action |
|-----|--------|
| `Super + Return` | Open terminal |
| `Super + D` | Application launcher |
| `Super + B` | Open browser |
| `Super + Q` | Close window |
| `Super + 1-9` | Switch workspace |

## 🔄 Updating Your System

```bash
# Update everything
sudo nixos-rebuild switch --flake /etc/nixos#home

# Update flake dependencies
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#home
```

## 🎨 Changing Theme

Edit `/etc/nixos/flake.nix`:

```nix
omarchy = {
  theme = "catppuccin";  # Change this line
};
```

Then rebuild:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

## 📦 Adding Software

Edit `/etc/nixos/flake.nix` in the `home.packages` section:

```nix
home.packages = with pkgs; [
  # Add your packages here
  slack
  discord
  spotify
];
```

Rebuild to apply:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

## 🔍 Finding Packages

```bash
# Search for a package
nix search nixpkgs firefox

# Or use the web interface
# https://search.nixos.org/packages
```

## 🆘 Getting Help

- Check logs: `journalctl -xe`
- Test config: `sudo nixos-rebuild build --flake /etc/nixos#home`
- Rollback: `sudo nixos-rebuild switch --rollback`
- Full documentation: See [README.md](README.md)

## 📝 Next Steps

1. **Change your password**: `passwd`
2. **Customize your config**: Edit `/etc/nixos/flake.nix`
3. **Set up Git**: Configure your dotfiles repository
4. **Explore Hyprland**: Check out the keybindings
5. **Install more software**: Add packages to your config

---

**Welcome to NixOS! 🎉**
