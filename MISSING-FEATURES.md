# ❌ Missing Features - What We Still Need

## Current Status

**What omarchy-nix provides:**
- ✅ Hyprland configuration (keybindings, animations, tiling)
- ✅ Waybar, Mako, Hyprlock, Hypridle
- ✅ Ghostty terminal config
- ✅ Basic theme system
- ✅ Core packages (~30)

**What's missing from full Omarchy:**

## 🎯 Critical Missing Features

### 1. Walker Launcher ❌
**Current:** Uses Wofi (basic launcher)  
**Omarchy:** Uses Walker (advanced launcher with menus, search, etc.)

**What Walker provides:**
- Application launcher
- Web search integration
- File search
- Calculator
- Clipboard history
- Symbol picker
- Custom menus
- dmenu mode for scripts

**Action needed:**
- [ ] Package Walker for NixOS (if not in nixpkgs)
- [ ] Port Walker config from Omarchy
- [ ] Configure Walker themes
- [ ] Replace Wofi with Walker in keybindings

### 2. Omarchy Menu System ❌
**Current:** No menu system  
**Omarchy:** Comprehensive menu system via `omarchy-menu`

**What the menu provides:**
- Learn menu (keybindings, docs)
- Trigger menu (screenshot, screenrecord, toggles)
- Manage menu (themes, packages, system)
- Install menu (apps, fonts, terminals)
- Configure menu (settings, tweaks)
- And many more...

**Action needed:**
- [x] Copy omarchy-menu script (DONE)
- [ ] Adapt for NixOS (replace pacman/yay commands)
- [ ] Test all menu options
- [ ] Ensure Walker integration works

### 3. Complete Config Files ❌
**Current:** Basic configs via omarchy-nix  
**Omarchy:** Full configs for all apps

**Missing configs:**
- Walker config
- Neovim full config (omarchy-nvim)
- Chromium config
- Alacritty config (if used)
- Kitty config (if used)
- Lazygit config
- Git config
- Starship config
- SwayOSD config
- And more...

**Action needed:**
- [ ] Copy all config files from `omarchy/config/`
- [ ] Add to flake.nix home-manager section
- [ ] Test each config

### 4. Omarchy Default Files ❌
**Current:** None  
**Omarchy:** Has `~/.local/share/omarchy/default/` with base configs

**What's in defaults:**
- Hyprland base configs (bindings, autostart, etc.)
- Walker themes
- Theme files
- Base configurations

**Action needed:**
- [ ] Copy `omarchy/default/` directory
- [ ] Add to flake.nix to install to `~/.local/share/omarchy/default/`
- [ ] Update scripts to reference these defaults

### 5. Theme System ❌
**Current:** Basic theme switching via omarchy-nix  
**Omarchy:** Full theme system with:
- Multiple themes (Tokyo Night, Catppuccin, etc.)
- Theme switching scripts
- Per-app theme configs
- Wallpaper integration

**Action needed:**
- [ ] Copy all theme files from `omarchy/themes/`
- [ ] Adapt theme-switching scripts for NixOS
- [ ] Test theme switching
- [ ] Ensure all apps respect themes

## 📦 Package Differences

### Missing Packages
Some Omarchy packages don't exist in NixOS or have different names:

- `omarchy-chromium` → Need to extract config and apply to `chromium`
- `omarchy-nvim` → Need to extract config and apply to `neovim`
- `omarchy-walker` → Need to extract config and apply to `walker`
- `elephant` → Clipboard manager (may need to package)
- `uwsm` → Session manager (may need to package)
- `aether` → (need to find NixOS equivalent)
- `impala` → (need to find NixOS equivalent)
- `tobi-try` → (need to find NixOS equivalent)
- `usage` → (need to find NixOS equivalent)
- `wiremix` → (need to find NixOS equivalent)
- `swayosd` → May need to build from source

### Custom Omarchy Packages
These are Arch packages with Omarchy customizations:
- Need to extract the customizations
- Apply to standard NixOS packages

## 🔧 Script Adaptations Needed

### High Priority (Package/Update Management)
- [ ] All `omarchy-pkg-*` scripts (15 scripts)
- [ ] All `omarchy-update-*` scripts (12 scripts)
- [ ] `omarchy-snapshot` (use NixOS generations)

### Medium Priority (System Management)
- [ ] All `omarchy-install-*` scripts (10 scripts)
- [ ] All `omarchy-refresh-*` scripts (15 scripts)
- [ ] All `omarchy-setup-*` scripts (5 scripts)

### Low Priority (Should work as-is)
- [ ] All `omarchy-launch-*` scripts (15 scripts) - mostly OK
- [ ] All `omarchy-theme-*` scripts (12 scripts) - need path adjustments
- [ ] All `omarchy-cmd-*` scripts (15 scripts) - mostly OK
- [ ] Utility scripts (30+ scripts) - mostly OK

## 🎨 Visual/UX Differences

### Current State
- ✅ Hyprland looks identical
- ✅ Waybar looks identical
- ✅ Keybindings are identical
- ❌ Launcher is different (Wofi vs Walker)
- ❌ No menu system
- ❌ Theme switching not fully working

### To Match Omarchy 100%
- [ ] Walker launcher with all features
- [ ] Full menu system working
- [ ] All themes available and switchable
- [ ] All configs matching Omarchy
- [ ] All scripts working

## 📊 Completion Estimate

**Current:** ~40% complete

**To reach 100%:**
1. **Walker + Configs** (1-2 weeks)
   - Package/configure Walker
   - Port all config files
   - Test everything

2. **Menu System** (1 week)
   - Adapt omarchy-menu for NixOS
   - Test all menu options
   - Fix any issues

3. **Script Adaptation** (2-3 weeks)
   - Adapt remaining 137 scripts
   - Test each one
   - Document changes

4. **Theme System** (1 week)
   - Port all themes
   - Test theme switching
   - Ensure all apps themed

5. **Testing & Polish** (1 week)
   - Test on real hardware
   - Fix bugs
   - Document everything

**Total:** 6-8 weeks for 100% parity

## 🚀 What Works Now

Despite missing features, users get:
- ✅ Beautiful Hyprland desktop
- ✅ All 143 packages
- ✅ Basic functionality
- ✅ Most keybindings
- ✅ Waybar, Mako, etc.
- ✅ Terminal, editor, browser
- ✅ Development tools

**It's usable now, just not 100% identical to Omarchy yet.**

## 🎯 Priority Order

1. **Walker launcher** - Most visible difference
2. **Menu system** - Core Omarchy feature
3. **Config files** - Ensure apps work correctly
4. **Script adaptation** - Full functionality
5. **Theme system** - Polish

## 📝 Next Immediate Actions

1. Check if Walker is in nixpkgs
2. If not, package Walker
3. Port Walker config
4. Copy all Omarchy config files
5. Copy Omarchy default files
6. Adapt omarchy-menu script
7. Test on real NixOS system

---

**Bottom line:** We have a solid foundation (~40% complete) that's deployable now. Remaining work is adding the polish and features that make it 100% Omarchy.
