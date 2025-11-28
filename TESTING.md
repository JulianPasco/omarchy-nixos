# 🧪 Testing Guide

## ✅ Successfully Pushed to GitHub!

**Repository:** https://github.com/JulianPasco/omarchy-nixos

**Installation Command:**
```bash
curl -fsSL https://raw.githubusercontent.com/JulianPasco/omarchy-nixos/main/install.sh | bash
```

## 🎯 How to Test

### Option 1: Test in a VM (Recommended)

**Using VirtualBox/VMware:**
1. Download NixOS ISO: https://nixos.org/download.html
2. Create new VM (8GB RAM, 40GB disk)
3. Install NixOS with default settings
4. Boot into NixOS
5. Run the installation command

**Using UTM (Mac):**
1. Download NixOS ISO
2. Create new VM
3. Follow same steps as above

### Option 2: Test on Real Hardware

**⚠️ Warning:** Only do this if you're comfortable with NixOS!

1. Boot NixOS live USB
2. Install NixOS to disk
3. Reboot into installed system
4. Run installation command

## 📋 Testing Checklist

### Installation Phase
- [ ] Installation script downloads successfully
- [ ] Script prompts for full name
- [ ] Script prompts for email
- [ ] Script prompts for username
- [ ] Script prompts for machine type (home/work)
- [ ] Repository clones successfully
- [ ] Hardware configuration generates
- [ ] System builds without errors
- [ ] Installation completes

### Post-Installation
- [ ] System boots successfully
- [ ] Hyprland login option appears
- [ ] Can log in with created user
- [ ] Hyprland starts correctly

### Visual Check
- [ ] Waybar appears at top
- [ ] Wallpaper loads
- [ ] Animations are smooth
- [ ] Windows tile correctly

### Keybindings Test
- [ ] `SUPER + SPACE` - Opens launcher (Wofi currently)
- [ ] `SUPER + ENTER` - Opens terminal (Ghostty)
- [ ] `SUPER + W` - Closes window
- [ ] `SUPER + 1-9` - Switch workspaces
- [ ] `SUPER + SHIFT + 1-9` - Move window to workspace
- [ ] `SUPER + V` - Toggle floating
- [ ] `SUPER + J` - Toggle split

### Package Check
- [ ] Run `which chromium` - Should exist
- [ ] Run `which lazygit` - Should exist
- [ ] Run `which btop` - Should exist
- [ ] Run `which gh` - Should exist
- [ ] Run `neovim` - Should open

### Script Check
- [ ] Run `omarchy-update` - Should work (adapted)
- [ ] Run `omarchy-pkg-install` - Should work (adapted)
- [ ] Check `ls ~/.local/share/omarchy/bin` - Should have 140 scripts
- [ ] Scripts are in PATH

### Known Issues to Expect

**✅ Working:**
- Hyprland desktop
- All keybindings
- Waybar
- Terminal
- All 143 packages
- Basic functionality

**⚠️ Not Yet Working:**
- Walker launcher (using Wofi instead)
- Omarchy menu system (scripts copied but not adapted)
- Some scripts need NixOS adaptation
- Theme switching may not work fully

## 🐛 If Something Breaks

### Build Fails
```bash
# Check the error message
# Common issues:
# - Package not found: Check package name in flake.nix
# - Syntax error: Check flake.nix syntax
# - Network issue: Try again
```

### Can't Log In
```bash
# Default password is "changeme"
# If that doesn't work, boot into recovery and reset password
```

### Hyprland Won't Start
```bash
# Check logs
journalctl -xe

# Try rebuilding
sudo nixos-rebuild switch --flake /etc/nixos#home
```

### Scripts Don't Work
```bash
# Check if scripts are in PATH
echo $PATH | grep omarchy

# Check if scripts exist
ls ~/.local/share/omarchy/bin

# Some scripts need adaptation - this is expected
```

## 📊 What to Report

After testing, please report:

**✅ What Worked:**
- Installation process
- Hyprland desktop
- Keybindings
- Packages
- Specific features

**❌ What Didn't Work:**
- Error messages
- Missing packages
- Broken scripts
- Visual issues
- Performance problems

**📝 System Info:**
- Hardware (CPU, RAM, GPU)
- NixOS version
- VM or real hardware
- Any custom settings

## 🎯 Success Criteria

**Minimum Success:**
- ✅ System installs
- ✅ Hyprland works
- ✅ Basic functionality works
- ✅ Looks like Omarchy

**Full Success:**
- ✅ Everything above
- ✅ All packages work
- ✅ All scripts work
- ✅ No errors
- ✅ Smooth experience

## 🚀 Quick Test Commands

Once installed, run these to verify:

```bash
# Check NixOS version
nixos-version

# Check installed packages
nix-env -q

# Check Hyprland version
hyprctl version

# Check if Omarchy scripts are available
omarchy-version

# List all Omarchy commands
ls ~/.local/share/omarchy/bin | wc -l  # Should be 140

# Test update system
omarchy-update

# Test package search
omarchy-pkg-install
```

## 📸 Screenshots to Take

If possible, take screenshots of:
1. Desktop with Waybar
2. Terminal open
3. Multiple windows tiled
4. Launcher (SUPER + SPACE)
5. Any errors encountered

## 🎉 After Testing

**If it works:**
1. Star the repository ⭐
2. Share screenshots
3. Report what worked well
4. Suggest improvements

**If it doesn't work:**
1. Don't panic!
2. Note the error
3. Check logs
4. Report the issue
5. We'll fix it together

## 📞 Getting Help

- **GitHub Issues:** https://github.com/JulianPasco/omarchy-nixos/issues
- **NixOS Discourse:** https://discourse.nixos.org/
- **Hyprland Discord:** https://discord.gg/hyprland

---

## 🎯 Current Status

**Version:** 0.1.0 (Initial Release)
**Status:** Alpha - Working but incomplete
**Completion:** ~40%

**What's ready:**
- ✅ Full package list (143 packages)
- ✅ All scripts copied (140 scripts)
- ✅ Hyprland configuration
- ✅ Installation system
- ✅ Basic functionality

**What's coming:**
- ⏳ Walker launcher
- ⏳ Full menu system
- ⏳ All scripts adapted
- ⏳ Complete config files
- ⏳ Theme system

**Expected experience:**
You'll get a beautiful, functional Hyprland system with all Omarchy packages. Some advanced features (menus, theme switching) aren't fully working yet, but the core experience is solid!

---

**Ready to test? Let's go!** 🚀

```bash
curl -fsSL https://raw.githubusercontent.com/JulianPasco/omarchy-nixos/main/install.sh | bash
```
