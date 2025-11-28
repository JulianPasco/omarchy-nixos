# 🎯 Full Omarchy Clone for NixOS - Implementation Plan

## Goal
Create a 100% feature-complete Omarchy clone for NixOS that:
- ✅ Looks identical to Omarchy
- ✅ Has all the same functionality
- ✅ Uses all the same keybindings
- ✅ Includes all Omarchy scripts (adapted for NixOS)
- ✅ Easy one-command installation
- ✅ Stays in sync with upstream Omarchy updates

## 📊 Current Status

### What We Have
- ✅ Basic flake structure
- ✅ Installation script
- ✅ Host configurations (home/work)
- ✅ Documentation
- ✅ GitHub repository setup

### What We're Missing
- ❌ 130+ Omarchy scripts (only have 1)
- ❌ Walker launcher (using Wofi)
- ❌ Full package list (~30 vs 140+)
- ❌ Omarchy menu system
- ❌ Theme switching scripts
- ❌ System management scripts
- ❌ Development environment scripts

## 🗺️ Implementation Phases

### Phase 1: Package Parity (Week 1)
**Goal:** Install all 140+ packages that Omarchy uses

**Tasks:**
1. ✅ Analyze `omarchy/install/omarchy-base.packages`
2. ✅ Map Arch package names to NixOS equivalents
3. ✅ Add all packages to `flake.nix`
4. ✅ Handle packages that don't exist in NixOS
5. ✅ Test package installation

**Files to modify:**
- `flake.nix` - Add all packages
- `PACKAGES.md` - Document package mappings

### Phase 2: Core Scripts (Week 2-3)
**Goal:** Port all 130+ Omarchy scripts to NixOS

**Categories:**

#### A. Package Management Scripts (15 scripts)
Replace `pacman`/`yay` with `nix-env`/`home-manager`
- `omarchy-pkg-install` → Use `nix search` + `nix-env -iA`
- `omarchy-pkg-remove` → Use `nix-env -e`
- `omarchy-pkg-add` → Add to flake.nix
- `omarchy-pkg-drop` → Remove from flake.nix
- `omarchy-pkg-missing` → Check if package exists
- `omarchy-pkg-present` → Check if package installed
- `omarchy-pkg-aur-install` → Not needed (NixOS has everything)
- etc.

#### B. Update Scripts (12 scripts)
Replace Arch update commands with NixOS rebuild
- `omarchy-update` → `nixos-rebuild switch`
- `omarchy-update-system-pkgs` → `nix flake update`
- `omarchy-update-git` → `git pull` in `/etc/nixos`
- `omarchy-update-keyring` → Not needed in NixOS
- `omarchy-update-firmware` → `fwupdmgr update`
- etc.

#### C. Theme Scripts (12 scripts)
Keep mostly the same, adjust paths
- `omarchy-theme-set`
- `omarchy-theme-next`
- `omarchy-theme-list`
- `omarchy-theme-bg-next`
- `omarchy-theme-set-browser`
- `omarchy-theme-set-vscode`
- `omarchy-theme-set-obsidian`
- etc.

#### D. Launch Scripts (15 scripts)
Keep the same
- `omarchy-launch-browser`
- `omarchy-launch-editor`
- `omarchy-launch-walker`
- `omarchy-launch-webapp`
- `omarchy-launch-tui`
- etc.

#### E. System Management (20 scripts)
Adapt for NixOS
- `omarchy-snapshot` → Use `nixos-rebuild list-generations`
- `omarchy-refresh-*` → Adapt for NixOS paths
- `omarchy-restart-*` → Keep mostly same
- `omarchy-setup-*` → Adapt for NixOS
- etc.

#### F. Command Scripts (15 scripts)
Keep mostly the same
- `omarchy-cmd-screenshot`
- `omarchy-cmd-screenrecord`
- `omarchy-cmd-audio-switch`
- `omarchy-cmd-share`
- etc.

#### G. Install Scripts (10 scripts)
Adapt for NixOS
- `omarchy-install-dev-env` → Add packages to flake
- `omarchy-install-docker-dbs` → NixOS docker config
- `omarchy-install-vscode` → Add to packages
- `omarchy-install-terminal` → Configure in flake
- etc.

#### H. Utility Scripts (30+ scripts)
Keep mostly the same
- `omarchy-menu`
- `omarchy-menu-keybindings`
- `omarchy-debug`
- `omarchy-state`
- `omarchy-version`
- etc.

### Phase 3: Walker Launcher (Week 4)
**Goal:** Replace Wofi with Walker

**Tasks:**
1. Package Walker for NixOS (if not already available)
2. Configure Walker with Omarchy settings
3. Port Walker configuration files
4. Test Walker functionality

**Files:**
- Add Walker package
- Configure Walker in home-manager
- Port Walker config from Omarchy

### Phase 4: Configuration Files (Week 4-5)
**Goal:** Port all Omarchy configuration files

**Files to port:**
- Hyprland config (already done via omarchy-nix)
- Waybar config (already done via omarchy-nix)
- Walker config
- Ghostty config (already done)
- Neovim config (needs work)
- All other app configs

### Phase 5: Menu System (Week 5)
**Goal:** Port the Omarchy menu system

**Tasks:**
1. Port `omarchy-menu` script
2. Port `omarchy-menu-keybindings` script
3. Ensure all menu options work on NixOS
4. Test menu functionality

### Phase 6: Sync Mechanism (Week 6)
**Goal:** Create system to sync with upstream Omarchy

**Tasks:**
1. Create GitHub Action to monitor Omarchy repo
2. Create script to check for Omarchy updates
3. Document how to merge upstream changes
4. Create testing workflow

**Files:**
- `.github/workflows/sync-omarchy.yml`
- `bin/check-omarchy-updates`
- `SYNCING.md` documentation

## 📁 New Repository Structure

```
omarchy-nixos/
├── flake.nix                    # Main flake with ALL packages
├── flake.lock
├── install.sh                   # One-command installer
├── hosts/
│   ├── home.nix
│   ├── work.nix
│   ├── hardware-home.nix
│   └── hardware-work.nix
├── bin/                         # ALL 130+ Omarchy scripts (adapted)
│   ├── omarchy-pkg-install
│   ├── omarchy-pkg-remove
│   ├── omarchy-update
│   ├── omarchy-theme-set
│   ├── omarchy-menu
│   ├── omarchy-launch-walker
│   └── ... (all other scripts)
├── config/                      # All Omarchy config files
│   ├── hyprland/
│   ├── waybar/
│   ├── walker/
│   ├── ghostty/
│   ├── neovim/
│   └── ...
├── themes/                      # All Omarchy themes
│   ├── tokyo-night/
│   ├── catppuccin/
│   └── ...
├── modules/                     # NixOS modules
│   ├── omarchy-base.nix        # Base system config
│   ├── omarchy-packages.nix    # All 140+ packages
│   ├── omarchy-scripts.nix     # Install all scripts
│   ├── omarchy-hyprland.nix    # Hyprland config
│   └── ...
├── docs/
│   ├── README.md
│   ├── QUICKSTART.md
│   ├── PACKAGES.md             # Package mappings
│   ├── SCRIPTS.md              # Script documentation
│   ├── SYNCING.md              # How to sync with upstream
│   └── ...
└── .github/
    └── workflows/
        ├── check.yml
        └── sync-omarchy.yml    # Monitor upstream
```

## 🔄 Syncing with Upstream Omarchy

### Strategy

1. **Monitor Omarchy Repository**
   - GitHub Action checks for new commits weekly
   - Notifies maintainers of changes
   - Creates issue with change summary

2. **Manual Review Process**
   - Review Omarchy changes
   - Determine if NixOS adaptation needed
   - Port changes to NixOS version
   - Test thoroughly
   - Merge and release

3. **Automated Where Possible**
   - Theme additions → Auto-port
   - Config file updates → Auto-port
   - Script additions → Notify for manual port
   - Package additions → Notify for manual port

### Sync Script

```bash
#!/usr/bin/env bash
# bin/check-omarchy-updates

# Clone latest Omarchy
git clone --depth 1 https://github.com/basecamp/omarchy /tmp/omarchy-latest

# Compare with our last sync
diff -r /tmp/omarchy-latest ./upstream-snapshot/ > changes.diff

# Parse changes
# - New scripts in bin/
# - New packages in install/*.packages
# - Config file changes
# - Theme changes

# Create GitHub issue with summary
gh issue create --title "Omarchy Update Available" --body "$(cat changes.diff)"
```

## 📦 Package Mapping Strategy

### Arch → NixOS Package Name Mapping

Many packages have different names:

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| `yay` | N/A | Not needed (nix handles everything) |
| `ttf-jetbrains-mono-nerd` | `jetbrains-mono` | Different naming |
| `omarchy-chromium` | `chromium` + config | Custom Arch package |
| `omarchy-nvim` | `neovim` + config | Custom Arch package |
| `omarchy-walker` | `walker` + config | Custom Arch package |

### Custom Omarchy Packages

Some Omarchy packages are custom-built for Arch. We need to:
1. Find the source
2. Package for NixOS
3. Or use equivalent NixOS packages

## 🧪 Testing Strategy

### Test Checklist

- [ ] All 140+ packages install correctly
- [ ] All 130+ scripts work on NixOS
- [ ] Walker launcher works
- [ ] All keybindings work
- [ ] Theme switching works
- [ ] Menu system works
- [ ] Update mechanism works
- [ ] Looks identical to Omarchy
- [ ] All Omarchy features present

### Testing Environments

1. **VM Testing** - Test on fresh NixOS VM
2. **Real Hardware** - Test on actual hardware
3. **Multiple Hosts** - Test home and work configs
4. **Upgrade Testing** - Test updates and rollbacks

## 📅 Timeline

### Aggressive Timeline (6 weeks)
- Week 1: Package parity
- Week 2-3: Core scripts
- Week 4: Walker + configs
- Week 5: Menu system
- Week 6: Sync mechanism + testing

### Realistic Timeline (12 weeks)
- Week 1-2: Package parity + testing
- Week 3-6: Core scripts (careful porting)
- Week 7-8: Walker + configs
- Week 9-10: Menu system
- Week 11: Sync mechanism
- Week 12: Final testing + documentation

## 🚀 Getting Started

### Immediate Next Steps

1. **Create Package List**
   ```bash
   # Extract all packages from Omarchy
   cat omarchy/install/omarchy-base.packages > PACKAGES-TO-PORT.txt
   cat omarchy/install/omarchy-other.packages >> PACKAGES-TO-PORT.txt
   ```

2. **Map to NixOS Packages**
   ```bash
   # For each package, find NixOS equivalent
   nix search nixpkgs <package-name>
   ```

3. **Start Porting Scripts**
   ```bash
   # Copy all scripts
   cp -r omarchy/bin/* nixos/bin/
   
   # Start adapting for NixOS
   # Replace pacman → nix commands
   # Replace yay → nix commands
   # Update paths for NixOS
   ```

4. **Test Incrementally**
   - Port one category at a time
   - Test each script
   - Document any issues

## 📝 Documentation Needs

### New Documentation Files

1. **PACKAGES.md** - Complete package mapping
2. **SCRIPTS.md** - All scripts and their NixOS adaptations
3. **SYNCING.md** - How to sync with upstream Omarchy
4. **PORTING-GUIDE.md** - Guide for porting new Omarchy features
5. **DIFFERENCES.md** - Any unavoidable differences from Omarchy

## 🤝 Contribution Guidelines

### For Future Contributors

1. Always test on fresh NixOS install
2. Document any Arch → NixOS changes
3. Keep scripts compatible with Omarchy where possible
4. Update package mappings
5. Test on multiple hardware configs

## ⚠️ Challenges & Solutions

### Challenge 1: AUR Packages
**Problem:** Omarchy uses AUR packages not in official repos  
**Solution:** Package for NixOS or find equivalents

### Challenge 2: Custom Omarchy Packages
**Problem:** `omarchy-chromium`, `omarchy-nvim`, etc.  
**Solution:** Extract configs and apply to standard NixOS packages

### Challenge 3: Pacman-Specific Scripts
**Problem:** Many scripts use `pacman` commands  
**Solution:** Create NixOS equivalents using `nix-env`, `home-manager`

### Challenge 4: Arch System Paths
**Problem:** Scripts reference `/usr/share`, `/etc/pacman.d`, etc.  
**Solution:** Update to NixOS paths `/run/current-system`, `/etc/nixos`

### Challenge 5: Keeping in Sync
**Problem:** Omarchy updates frequently  
**Solution:** Automated monitoring + manual review process

## 🎯 Success Criteria

### Definition of "100% Clone"

1. ✅ **Visual Parity** - Looks identical to Omarchy
2. ✅ **Feature Parity** - All Omarchy features work
3. ✅ **Script Parity** - All 130+ scripts present and working
4. ✅ **Package Parity** - All 140+ packages installed
5. ✅ **Keybinding Parity** - All keybindings identical
6. ✅ **Menu Parity** - Menu system works identically
7. ✅ **Theme Parity** - All themes available
8. ✅ **Update Parity** - Easy updates like Omarchy

### Acceptable Differences

- Package manager commands (nix vs pacman)
- System paths (NixOS vs Arch)
- Update mechanism (nixos-rebuild vs pacman -Syu)
- Snapshot mechanism (generations vs timeshift)

## 📞 Questions to Answer

1. Should we fork omarchy-nix or start fresh?
2. How to handle custom Omarchy packages?
3. Should we contribute back to omarchy-nix?
4. How to handle Walker if not in nixpkgs?
5. Testing infrastructure?

## 🎉 End Goal

A NixOS distribution that:
- Installs with one command
- Looks and works exactly like Omarchy
- Stays in sync with Omarchy updates
- Provides all Omarchy features
- Uses declarative NixOS configuration
- Easy to maintain and extend

---

**This is a significant project but absolutely achievable!**

Would you like to start with Phase 1 (Package Parity)?
