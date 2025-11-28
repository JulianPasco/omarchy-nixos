# 🎯 Action Plan - Reach 100% Omarchy Parity

## Current Status: ~40% Complete

**What we have:**
- ✅ All 143 packages
- ✅ All 140 scripts (3 adapted, 137 ready)
- ✅ Hyprland base config (via omarchy-nix)
- ✅ Installation system working

**What's missing:**
- ❌ Walker launcher (using Wofi)
- ❌ Omarchy menu system
- ❌ Full config files
- ❌ Omarchy default files
- ❌ Complete theme system
- ❌ 137 scripts need NixOS adaptation

## 📋 Immediate Next Steps (This Week)

### Step 1: Add Walker Launcher
**Priority:** CRITICAL - Most visible difference

```bash
# Check if Walker is in nixpkgs
nix search nixpkgs walker

# If yes: Add to flake.nix packages
# If no: Need to package it ourselves
```

**Tasks:**
1. [ ] Verify Walker availability in nixpkgs
2. [ ] Add Walker to flake.nix packages
3. [ ] Copy Walker config from `omarchy/config/walker/`
4. [ ] Copy Walker themes from `omarchy/default/walker/`
5. [ ] Update keybindings to use Walker instead of Wofi
6. [ ] Test Walker functionality

**Files to modify:**
- `flake.nix` - Add walker package
- Add `config/walker/config.toml`
- Add `default/walker/themes/`
- Update Hyprland bindings

### Step 2: Copy All Config Files
**Priority:** HIGH - Ensures apps work correctly

**Tasks:**
1. [ ] Create `config/` directory structure
2. [ ] Copy all configs from `omarchy/config/`:
   - [ ] hypr/ (10 files)
   - [ ] walker/
   - [ ] waybar/
   - [ ] ghostty/
   - [ ] git/
   - [ ] lazygit/
   - [ ] starship.toml
   - [ ] fastfetch/
   - [ ] btop/
   - [ ] chromium/
   - [ ] kitty/
   - [ ] alacritty/
   - [ ] And all others...
3. [ ] Add configs to flake.nix home-manager section
4. [ ] Test each config

**Command to copy:**
```bash
cp -r omarchy/config/* nixos/config/
```

### Step 3: Copy Omarchy Default Files
**Priority:** HIGH - Required for scripts to work

**Tasks:**
1. [ ] Copy `omarchy/default/` directory
2. [ ] Add to flake.nix to install to `~/.local/share/omarchy/default/`
3. [ ] Verify scripts can find defaults

**Command:**
```bash
cp -r omarchy/default nixos/default
```

### Step 4: Adapt Omarchy Menu
**Priority:** HIGH - Core Omarchy feature

**Tasks:**
1. [x] Menu script already copied
2. [ ] Replace `pacman` commands with `nix-env`
3. [ ] Replace `yay` commands with nix equivalents
4. [ ] Test all menu options
5. [ ] Fix any broken menu items

**Files:**
- `bin/omarchy-menu` - Main menu
- `bin/omarchy-menu-keybindings` - Keybindings menu

## 📅 Week-by-Week Plan

### Week 1: Walker + Configs
- [ ] Add Walker launcher
- [ ] Copy all config files
- [ ] Copy default files
- [ ] Test basic functionality

### Week 2: Menu System
- [ ] Adapt omarchy-menu for NixOS
- [ ] Test all menu options
- [ ] Fix package installation menus
- [ ] Fix system management menus

### Week 3-4: Script Adaptation (Priority 1)
- [ ] Adapt all package management scripts (15)
- [ ] Adapt all update scripts (12)
- [ ] Adapt snapshot/generation scripts
- [ ] Test each adapted script

### Week 5: Script Adaptation (Priority 2)
- [ ] Adapt install scripts (10)
- [ ] Adapt refresh scripts (15)
- [ ] Adapt setup scripts (5)
- [ ] Test system management

### Week 6: Theme System
- [ ] Copy all theme files
- [ ] Adapt theme-switching scripts
- [ ] Test theme switching
- [ ] Ensure all apps themed correctly

### Week 7: Testing & Polish
- [ ] Test on real NixOS hardware
- [ ] Fix any bugs
- [ ] Update documentation
- [ ] Create video demo

### Week 8: Release
- [ ] Final testing
- [ ] Update README
- [ ] Create release notes
- [ ] Announce to community

## 🔧 Technical Tasks

### Package Walker (if not in nixpkgs)
```nix
# In flake.nix, add:
walker = pkgs.stdenv.mkDerivation {
  pname = "walker";
  version = "latest";
  src = pkgs.fetchFromGitHub {
    owner = "abenz1267";
    repo = "walker";
    rev = "main";
    sha256 = "...";
  };
  # Build instructions
};
```

### Add All Configs to Flake
```nix
# In flake.nix home-manager section:
home.file = {
  ".config/walker".source = ./config/walker;
  ".config/hypr".source = ./config/hypr;
  ".config/waybar".source = ./config/waybar;
  ".config/ghostty".source = ./config/ghostty;
  ".config/lazygit".source = ./config/lazygit;
  ".config/starship.toml".source = ./config/starship.toml;
  # ... all other configs
  
  ".local/share/omarchy/default".source = ./default;
};
```

### Adapt Menu Script Example
```bash
# Old (Arch):
install() {
  present_terminal "echo 'Installing $1...'; sudo pacman -S --noconfirm $2"
}

# New (NixOS):
install() {
  present_terminal "echo 'Installing $1...'; nix-env -iA nixpkgs.$2"
}
```

## 📊 Progress Tracking

Create checkboxes for each task:

**Walker Launcher:**
- [ ] Walker in nixpkgs verified
- [ ] Walker added to flake.nix
- [ ] Walker config copied
- [ ] Walker themes copied
- [ ] Keybindings updated
- [ ] Walker tested

**Config Files:**
- [ ] All configs copied
- [ ] Configs added to flake.nix
- [ ] Hyprland configs tested
- [ ] Walker config tested
- [ ] Waybar config tested
- [ ] Terminal configs tested
- [ ] All other configs tested

**Menu System:**
- [ ] omarchy-menu adapted
- [ ] Learn menu working
- [ ] Trigger menu working
- [ ] Manage menu working
- [ ] Install menu working
- [ ] Configure menu working

**Scripts (Priority 1):**
- [ ] Package management (15/15)
- [ ] Update scripts (12/12)
- [ ] Snapshot scripts adapted

**Scripts (Priority 2):**
- [ ] Install scripts (10/10)
- [ ] Refresh scripts (15/15)
- [ ] Setup scripts (5/5)

**Theme System:**
- [ ] All themes copied
- [ ] Theme switching working
- [ ] All apps themed

## 🎯 Success Criteria

System is 100% Omarchy clone when:
- ✅ Walker launcher works identically
- ✅ All menus work
- ✅ All 140 scripts work
- ✅ All configs match Omarchy
- ✅ Theme switching works
- ✅ Looks identical to Omarchy
- ✅ All keybindings identical
- ✅ All features present

## 🚀 Quick Start (Do This Now)

```bash
cd nixos

# 1. Copy configs
cp -r ../omarchy/config/* config/

# 2. Copy defaults
cp -r ../omarchy/default .

# 3. Update flake.nix to include walker and all configs

# 4. Test build
nix flake check

# 5. Commit progress
git add .
git commit -m "Add Walker, configs, and defaults"
git push
```

## 📞 Questions to Answer

1. **Is Walker in nixpkgs?**
   - Run: `nix search nixpkgs walker`
   - If yes: Easy, just add to packages
   - If no: Need to package it

2. **Do we need elephant (clipboard manager)?**
   - Check if in nixpkgs
   - Or find alternative

3. **Do we need uwsm (session manager)?**
   - Check if in nixpkgs
   - Or adapt scripts to not need it

4. **Which configs are critical?**
   - Walker - YES
   - Hyprland - Already have via omarchy-nix
   - Waybar - Already have via omarchy-nix
   - Others - Nice to have

## 💡 Tips

- **Test incrementally** - Don't copy everything at once
- **One feature at a time** - Walker first, then menus, then scripts
- **Use VM for testing** - Don't break your main system
- **Document changes** - Note what you adapt and why
- **Ask for help** - NixOS community is helpful

---

**Let's start with Walker and configs this week!** 🚀
