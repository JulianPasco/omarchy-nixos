# Omarchy Themes on NixOS

Your NixOS Omarchy setup now includes **all 14 original Omarchy themes**!

## 📦 Available Themes

1. **catppuccin** (Mocha - dark)
2. **catppuccin-latte** (light)
3. **ethereal** (dark)
4. **everforest** (dark)
5. **flexoki-light**
6. **gruvbox** (dark)
7. **hackerman** (dark, Matrix-style)
8. **kanagawa** (dark)
9. **matte-black** (dark)
10. **nord** (dark)
11. **osaka-jade** (dark)
12. **ristretto** (dark)
13. **rose-pine** (dark)
14. **tokyo-night** (dark) - **DEFAULT**

## 🎨 How to Switch Themes

### Method 1: Via Omarchy Menu (Recommended)

1. Press **Super + Alt + Space** (Omarchy Menu)
2. Type **"themes"** or **"style"**
3. Select **"Omarchy Themes"**
4. Browse themes with preview images
5. Click on a theme to activate it

### Method 2: Via Terminal

```bash
# List all available themes
omarchy-theme-list

# Set a specific theme
omarchy-theme-set nord
omarchy-theme-set catppuccin
omarchy-theme-set gruvbox

# Cycle to next theme
omarchy-theme-next
```

### Method 3: Edit Flake (For Default Theme)

Edit `flake.nix` and change the default theme symlink:

```nix
file.".config/omarchy/current/theme" = {
  source = ../omarchy/themes/nord;  # Change "nord" to your preferred theme
};
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#work
```

## 🎯 What Gets Themed

Each theme styles:

- ✅ **Desktop** - Background wallpaper
- ✅ **Waybar** - Top bar colors
- ✅ **Terminal** (Ghostty/Kitty) - Terminal colors
- ✅ **Neovim** - Editor theme
- ✅ **btop** - Activity monitor
- ✅ **Mako** - Notifications
- ✅ **Walker** - App launcher
- ✅ **Hyprlock** - Lock screen
- ✅ **Hyprland** - Window borders, gaps

## 🔄 Auto-Apply on Theme Change

When you run `omarchy-theme-set`, it automatically:
1. Updates the symlink at `~/.config/omarchy/current/theme/`
2. Reloads Waybar
3. Reloads SwayOSD
4. Reloads Mako
5. Applies GNOME, browser, and VSCode theme (if installed)

## 🖼️ Background Images

Some themes have multiple background images. To cycle through them:

```bash
# Rotate to next background
# Super + Ctrl + Space (if keybinding is configured)
omarchy-theme-bg-next
```

Or access via:
- **Omarchy Menu** → **Capture** → **Background**

## 📁 Theme Locations

- **Theme files:** `~/.config/omarchy/themes/`
- **Current theme (symlink):** `~/.config/omarchy/current/theme/`
- **Theme backgrounds:** `~/.config/omarchy/themes/<theme-name>/backgrounds/`

## 🎨 Custom Themes

You can add your own themes:

1. Copy an existing theme as a template:
   ```bash
   cp -r ~/.config/omarchy/themes/nord ~/.config/omarchy/themes/my-theme
   ```

2. Edit the theme files:
   - `hyprland.conf` - Window colors
   - `waybar.css` - Bar styling
   - `kitty.conf` / `ghostty.conf` - Terminal colors
   - `btop.theme` - Activity monitor
   - `neovim.lua` - Editor theme
   - `mako.ini` - Notification colors
   - `walker.css` - App launcher
   - `backgrounds/` - Add your wallpapers

3. Activate your theme:
   ```bash
   omarchy-theme-set my-theme
   ```

## 🔧 Troubleshooting

**Theme not applying?**
```bash
# Check current theme
ls -l ~/.config/omarchy/current/theme

# Manually reload components
omarchy-restart-waybar
makoctl reload
pkill walker
```

**Missing theme previews in Walker?**
- Ensure themes have `preview.png` or images in `backgrounds/` folder

**btop not showing theme?**
- Check symlink: `ls -l ~/.config/btop/themes/current.theme`
- Should point to: `~/.config/omarchy/current/theme/btop.theme`

---

🚀 Enjoy your beautiful, customizable Omarchy desktop on NixOS!
