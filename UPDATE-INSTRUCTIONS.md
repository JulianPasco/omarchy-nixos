# 🚀 Update Instructions for Work Machine

## What's Been Added

### ✅ Complete Waybar Configuration
- Custom waybar config with **🚀 NixOS** test indicator
- All Omarchy modules (CPU, network, bluetooth, volume)
- Stored in `~/.config/waybar-custom/` to avoid conflicts
- Power/logout menu accessible via Omarchy menu

### ✅ Full Theme Support (14 Themes!)
- All original Omarchy themes installed
- Theme switcher via Walker/Elephant
- Default theme: Tokyo Night
- Includes catppuccin, nord, gruvbox, rose-pine, and more!

### ✅ Omarchy Scripts & Default Configs
- All Omarchy bin scripts in PATH
- Waybar indicators
- Theme management scripts
- OMARCHY_PATH environment variable set

### ✅ Optional: Deskflow
- Software KVM package ready to uncomment
- Share mouse/keyboard across computers

---

## 📋 Steps to Update Your Work Machine

### 1️⃣ Pull Latest Changes

```bash
cd /etc/nixos

# Commit any local changes first
sudo git add .
sudo git commit -m "Local hardware config and changes"

# Pull the updates
sudo git pull --rebase
```

### 2️⃣ Rebuild System

```bash
# Build and switch to new config
sudo nixos-rebuild switch --flake .#work

# This will:
# - Install waybar with custom config
# - Install all 14 Omarchy themes
# - Set up theme switcher
# - Configure Omarchy scripts
```

### 3️⃣ Restart Waybar

```bash
# Restart waybar service
systemctl --user restart waybar

# Or kill and check manually
pkill waybar
waybar -c ~/.config/waybar-custom/config -s ~/.config/waybar-custom/style.css &
```

---

## ✅ Verification Steps

### Check Waybar Config
```bash
# Should show our custom config starting with {
cat ~/.config/waybar-custom/config | head -10

# Should see:
# {
#   "reload_style_on_change": true,
#   "modules-left": ["custom/omarchy", "custom/nixos-test", ...
```

### Visual Check
Look at your waybar (top bar):

**Left side:**
- ⚙️ Gear icon (Omarchy menu)
- **🚀 NixOS** text (proves our config is active!)
- Workspace numbers (1 2 3 4 5)

**Center:**
- Clock
- Update indicator (if available)

**Right side:**
- Tray expander (►)
- Bluetooth icon
- Network icon
- Volume icon
- CPU icon
- Battery icon (only on laptops, not desktops)

### Test Themes
```bash
# List available themes
omarchy-theme-list

# Or via Omarchy menu:
# Press Super + Alt + Space
# Type "themes"
# Browse and select a theme
```

---

## 🎨 Using Themes

### Quick Theme Switch
1. **Super + Alt + Space** (Omarchy Menu)
2. Type **"themes"**
3. Select **"Omarchy Themes"**
4. Browse with preview images
5. Click to activate

### Available Themes
- catppuccin (dark)
- catppuccin-latte (light)
- ethereal
- everforest
- flexoki-light
- gruvbox
- hackerman (Matrix-style!)
- kanagawa
- matte-black
- nord
- osaka-jade
- ristretto
- rose-pine
- **tokyo-night** (default)

### Theme Affects:
- Desktop background
- Waybar colors
- Terminal (Ghostty/Kitty)
- Neovim
- btop
- Notifications (Mako)
- App launcher (Walker)
- Lock screen (Hyprlock)

---

## 🎯 Access Logout/Power Menu

Since you're on a desktop (no battery icon), access the power menu via:

1. **Click ⚙️ gear icon** → Omarchy menu → System
2. **Super + Alt + Space** → Omarchy menu → System
3. **Super + Escape** → Direct system menu

---

## 🐛 Troubleshooting

### Waybar Not Showing 🚀 NixOS?

```bash
# Check which config is loaded
cat ~/.config/waybar/config | head -5

# If it still shows the old config (starts with [)
# Force remove it:
rm -rf ~/.config/waybar/*

# Rebuild
sudo nixos-rebuild switch --flake .#work
systemctl --user restart waybar
```

### Themes Not Appearing?

```bash
# Check themes directory
ls ~/.config/omarchy/themes/

# Should show 14 theme directories

# Check current theme symlink
ls -l ~/.config/omarchy/current/theme

# Should point to a theme directory
```

### Waybar Service Issues?

```bash
# Check service status
systemctl --user status waybar

# View logs
journalctl --user -u waybar -f

# Restart service
systemctl --user restart waybar
```

---

## 🎁 Optional: Enable Deskflow

If you want to share mouse/keyboard with other PCs:

1. Edit `flake.nix` line 208
2. Uncomment: `deskflow`
3. Rebuild: `sudo nixos-rebuild switch --flake .#work`
4. Launch: `deskflow` (GUI will open)

---

## 📚 Documentation

- **Themes:** See [THEMES.md](THEMES.md)
- **Package Audit:** See [PACKAGE-AUDIT.md](PACKAGE-AUDIT.md)
- **Comparison:** See [OMARCHY-COMPARISON.md](OMARCHY-COMPARISON.md)

---

## ✨ Summary

After updating, you'll have:
- ✅ Full Omarchy waybar with custom config
- ✅ 14 beautiful themes with live previews
- ✅ Theme switcher via Walker
- ✅ All Omarchy scripts functional
- ✅ Proof indicator (🚀 NixOS) on waybar
- ✅ Access to power/logout menu
- ✅ Optional Deskflow for multi-PC setup

Enjoy your fully-themed Omarchy NixOS desktop! 🚀
