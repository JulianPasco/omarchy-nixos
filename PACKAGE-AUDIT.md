# Package Audit - Duplicates & Issues

## Packages Provided by omarchy-nix

### Programs (via programs.X.enable)
These are configured via Home Manager modules:
- ✅ `neovim` - programs.neovim.enable = true
- ✅ `git` - programs.git (with user config)
- ✅ `gh` - programs.gh (GitHub CLI)
- ✅ `ghostty` - programs.ghostty (terminal)
- ✅ `starship` - programs.starship (prompt)
- ✅ `zsh` - programs.zsh
- ✅ `zoxide` - programs.zoxide
- ✅ `btop` - programs.btop
- ✅ `direnv` - programs.direnv
- ✅ `hyprlock` - programs.hyprlock
- ✅ `waybar` - programs.waybar
- ✅ `wofi` - programs.wofi (deprecated, replaced by walker)
- ✅ `vscode` - programs.vscode

### Packages (via home.packages)
From `modules/packages.nix`:

**Hyprland Ecosystem:**
- ✅ `hyprshot`
- ✅ `hyprpicker`
- ✅ `hyprsunset`
- ✅ `brightnessctl`
- ✅ `pamixer`
- ✅ `playerctl`
- ✅ `pavucontrol`

**System Packages:**
- ✅ `git`
- ✅ `vim`
- ✅ `libnotify`
- ✅ `nautilus`
- ✅ `alejandra`
- ✅ `blueberry`
- ✅ `clipse`
- ✅ `fzf`
- ✅ `zoxide`
- ✅ `ripgrep`
- ✅ `eza`
- ✅ `fd`
- ✅ `curl`
- ✅ `unzip`
- ✅ `wget`
- ✅ `gnumake`
- ✅ `gnome-themes-extra`

**Discretionary Packages:**
- ✅ `lazygit`
- ✅ `lazydocker`
- ✅ `btop`
- ✅ `powertop`
- ✅ `fastfetch`
- ✅ `chromium`
- ✅ `obsidian`
- ✅ `vlc`
- ✅ `signal-desktop`
- ✅ `github-desktop`
- ✅ `gh`
- ✅ `docker-compose`
- ✅ `ffmpeg`
- ✅ `typora` (x86_64-linux only)
- ✅ `dropbox` (x86_64-linux only)
- ✅ `spotify` (x86_64-linux only)

---

## Current Duplicates in Your Config

### ✅ Already Fixed
- ❌ `neovim` - REMOVED (provided by omarchy-nix)
- ❌ `hyprland` - REMOVED (provided by omarchy-nix)
- ❌ `hypridle` - REMOVED (provided by omarchy-nix)
- ❌ `hyprlock` - REMOVED (provided by omarchy-nix)
- ❌ `hyprpicker` - REMOVED (provided by omarchy-nix)
- ❌ `hyprsunset` - REMOVED (provided by omarchy-nix)
- ❌ `mako` - REMOVED (provided by omarchy-nix)
- ❌ `waybar` - REMOVED (provided by omarchy-nix)
- ❌ `xdg-desktop-portal-hyprland` - REMOVED (provided by omarchy-nix)
- ❌ `nwg-dock-hyprland` - REMOVED (not used by Omarchy)

### ⚠️ Current Duplicates (Safe but Redundant)

These are in your `home.packages` AND provided by omarchy-nix:

**Core Tools:**
- `git` - duplicate (omarchy-nix provides via programs.git)
- `gh` - duplicate (omarchy-nix provides via programs.gh)
- `fzf` - duplicate
- `zoxide` - duplicate (omarchy-nix provides via programs.zoxide)
- `ripgrep` - duplicate
- `eza` - duplicate
- `fd` - duplicate
- `unzip` - duplicate
- `nautilus` - duplicate
- `gnome-themes-extra` - duplicate

**Hyprland Tools:**
- `brightnessctl` - duplicate
- `pamixer` - duplicate
- `playerctl` - duplicate

**TUI Tools:**
- `lazygit` - duplicate
- `lazydocker` - duplicate
- `fastfetch` - duplicate

**Applications:**
- `chromium` - duplicate
- `obsidian` - duplicate
- `signal-desktop` - duplicate
- `typora` - duplicate
- `spotify` - duplicate

**Programs (configured by omarchy-nix):**
- `starship` - duplicate (omarchy-nix enables programs.starship)
- `ghostty` - duplicate (omarchy-nix enables programs.ghostty)

---

## Recommendations

### Option 1: Keep Duplicates (Current Approach)
**Pros:**
- Works fine (no conflicts)
- Explicit about what you want
- Easy to see all packages in one place

**Cons:**
- Redundant (wastes a tiny bit of disk space)
- May cause confusion
- Harder to maintain

### Option 2: Remove All Duplicates (Clean Approach)
**Pros:**
- Clean, minimal config
- Trust omarchy-nix to provide everything
- Easier to maintain

**Cons:**
- Less explicit
- Need to check omarchy-nix to see what's included

### Option 3: Hybrid (Recommended)
**Keep in your config:**
- Packages NOT in omarchy-nix
- Packages you explicitly want to control versions of
- Development tools specific to your workflow

**Remove from your config:**
- Core Hyprland ecosystem (already provided)
- Common CLI tools (already provided)
- Applications already in omarchy-nix discretionary list

---

## Packages to Keep (Not in omarchy-nix)

These are UNIQUE to your config and should stay:

**Core Tools:**
- `_1password-gui`, `_1password-cli`
- `bash-completion`
- `bat`
- `btop` (also in omarchy but you may want explicit control)
- `clang`, `llvm`
- `cups`, `cups-filters`
- `docker`, `docker-buildx` (docker-compose is in omarchy)
- `dust`
- `evince`
- `exfatprogs`
- `ffmpegthumbnailer`
- `fontconfig`
- `grim`
- `gum`
- `imagemagick`
- `imv`
- `inetutils`
- `inxi`
- `jq`
- `less`
- `libsecret`
- `libyaml`
- `libqalculate`
- `luarocks`
- `man`
- `mariadb`
- `mise`
- `mpv`
- `pinta`
- `plocate`
- `polkit_gnome`
- `postgresql`
- `ruby`
- `rustc`
- `satty`
- `slurp`
- `sushi`
- `swaybg`
- `tldr`
- `tree-sitter`
- `whois`
- `wireless-regdb`
- `wireplumber`
- `wl-clipboard`
- `xmlstarlet`
- `xournalpp`

**Wayland:**
- `wayfreeze`
- `xdg-desktop-portal-gtk`

**GNOME Apps:**
- `gnome-calculator`
- `gnome-keyring`
- `gnome-disk-utility`
- `gvfs`

**Fonts:**
- `noto-fonts`
- `noto-fonts-cjk-sans`
- `noto-fonts-color-emoji`
- `font-awesome`
- `nerd-fonts.caskaydia-mono`
- `nerd-fonts.jetbrains-mono`

**Input Methods:**
- `fcitx5`
- `fcitx5-gtk`

**Qt/KDE:**
- `libsForQt5.qtstyleplugin-kvantum`
- `qt5.qtwayland`

**Python:**
- `python3Packages.pygobject3`
- `python3Packages.poetry-core`

**Applications:**
- `libreoffice-fresh`
- `google-chrome`
- `onlyoffice-desktopeditors`
- `windsurf`

**System Tools:**
- `system-config-printer`
- `power-profiles-daemon`
- `localsend`

---

## Action Items

### High Priority
1. ✅ Remove duplicate Hyprland packages (DONE)
2. ✅ Remove neovim duplicate (DONE)
3. ✅ Remove nwg-dock (DONE)

### Medium Priority (Optional Cleanup)
4. ⏳ Remove duplicate CLI tools (git, gh, fzf, zoxide, ripgrep, eza, fd, unzip)
5. ⏳ Remove duplicate applications (chromium, obsidian, signal-desktop, typora, spotify)
6. ⏳ Remove duplicate Hyprland tools (brightnessctl, pamixer, playerctl)
7. ⏳ Remove duplicate TUI tools (lazygit, lazydocker, fastfetch)
8. ⏳ Remove duplicate GNOME (nautilus, gnome-themes-extra)
9. ⏳ Remove starship and ghostty (configured by omarchy-nix)

### Low Priority
10. ⏳ Document why certain packages are kept explicitly
11. ⏳ Consider using omarchy-nix's exclude_packages feature if you want to override specific packages

---

## Summary

**Current State:**
- ✅ No conflicts (system builds successfully)
- ⚠️ ~30 duplicate packages (safe but redundant)
- ✅ ~80 unique packages (not in omarchy-nix)

**Recommendation:**
- Keep current config as-is (it works!)
- Optionally clean up duplicates for a leaner config
- Focus on testing the actual system functionality

The duplicates are harmless - they just mean the same package is referenced twice but only installed once by Nix.
