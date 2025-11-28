# Deployment Checklist

This document guides you through deploying this configuration to GitHub and making it available for installation.

## 📋 Pre-Deployment Checklist

- [ ] All files created and reviewed
- [ ] Configuration tested locally (if possible)
- [ ] README.md is complete and accurate
- [ ] install.sh script is executable
- [ ] License file is present
- [ ] .gitignore is configured

## 🚀 Step 1: Initialize Git Repository

```bash
cd /path/to/nixos

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Omnixy NixOS configuration"
```

## 🌐 Step 2: Create GitHub Repository

### Option A: Using GitHub CLI (gh)

```bash
# Install gh if not available
nix-shell -p gh

# Login to GitHub
gh auth login

# Create repository (choose your own name)
gh repo create YOUR-REPO-NAME --public --source=. --remote=origin

# Push code
git push -u origin main
```

### Option B: Using GitHub Web Interface

1. Go to https://github.com/new
2. Repository name: `omnixy`
3. Description: "Omarchy-style NixOS configuration with one-command installation"
4. Choose: Public
5. Do NOT initialize with README (we have one)
6. Click "Create repository"

Then push:
```bash
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
git branch -M main
git push -u origin main
```

## 🔧 Step 3: Configure Repository

### Enable GitHub Actions

1. Go to repository Settings
2. Click "Actions" → "General"
3. Enable "Allow all actions and reusable workflows"
4. Save

### Add Repository Description

1. Go to repository main page
2. Click ⚙️ next to "About"
3. Add description: "Omarchy-inspired NixOS configuration using omarchy-nix"
4. Add topics: `nixos`, `hyprland`, `omarchy`, `omarchy-nix`, `linux`, `dotfiles`, `nix-flake`
5. Save

### Create Repository Topics

Add these topics to help people find your repo:
- nixos
- hyprland
- omarchy
- wayland
- nix-flakes
- linux-desktop
- dotfiles
- declarative-configuration

## 📝 Step 4: Update URLs in Files

Make sure these files have the correct GitHub URL:

### install.sh
```bash
REPO_URL="https://github.com/YOUR-USERNAME/YOUR-REPO-NAME"
```

### README.md
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO-NAME/main/install.sh | bash
```

### flake.nix
Check the installer app has correct URL.

## ✅ Step 5: Test Installation

### Test the curl command

On a NixOS system (or VM):

```bash
# Test downloading the script
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO-NAME/main/install.sh

# Test full installation (in VM recommended)
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO-NAME/main/install.sh | bash
```

### Test flake directly

```bash
# Test flake check
nix flake check github:YOUR-USERNAME/YOUR-REPO-NAME

# Test building
nix build github:YOUR-USERNAME/YOUR-REPO-NAME#nixosConfigurations.home.config.system.build.toplevel
```

## 🎨 Step 6: Add Visual Assets (Optional)

### Create Screenshots

Take screenshots of:
1. Hyprland desktop with wallpaper
2. Terminal with neofetch
3. Application launcher
4. Waybar and dock

Add to repository:
```bash
mkdir -p assets/screenshots
# Add your screenshots
git add assets/
git commit -m "Add screenshots"
git push
```

### Update README with Screenshots

Add to README.md:
```markdown
## 📸 Screenshots

![Desktop](assets/screenshots/desktop.png)
![Terminal](assets/screenshots/terminal.png)
```

## 📢 Step 7: Announce Your Configuration

### Create a Release

1. Go to repository → Releases
2. Click "Create a new release"
3. Tag: `v1.0.0`
4. Title: "Initial Release"
5. Description:
   ```markdown
   # Omnixy v1.0.0
   
   First stable release of Omnixy - Omarchy-style NixOS configuration.
   
   ## Features
   - One-command installation
   - Hyprland with Omarchy setup
   - Multi-host support (home/work)
   - Automatic hardware detection
   
   ## Installation
   ```bash
   curl -fsSL https://raw.githubusercontent.com/thearctesian/omnixy/main/install.sh | bash
   ```
   
   See [README.md](README.md) for full documentation.
   ```
6. Publish release

### Share on Social Media

Share on:
- Reddit: r/NixOS, r/unixporn
- Twitter/X with #NixOS #Hyprland
- Mastodon
- Discord: NixOS server

Example post:
```
🚀 Just released my NixOS configuration - a one-command installation that gives you 
a beautiful Hyprland setup inspired by Omarchy using omarchy-nix!

Features:
✅ Single curl command installation
✅ Omarchy-style Hyprland config via omarchy-nix
✅ Declarative & reproducible
✅ Easy sync between machines

Check it out: https://github.com/YOUR-USERNAME/YOUR-REPO-NAME

#NixOS #Hyprland #Linux
```

## 🔄 Step 8: Ongoing Maintenance

### Regular Updates

```bash
# Update flake inputs weekly/monthly
cd /path/to/omnixy
nix flake update
git add flake.lock
git commit -m "Update flake inputs"
git push
```

### Monitor Issues

1. Enable GitHub notifications
2. Respond to issues promptly
3. Label issues appropriately
4. Close resolved issues

### Accept Pull Requests

1. Review code changes
2. Test locally if possible
3. Merge if appropriate
4. Thank contributors

## 📊 Step 9: Add Badges to README (Optional)

Add to top of README.md:

```markdown
[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue.svg)](https://nixos.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-latest-green.svg)](https://hyprland.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/thearctesian/omnixy.svg)](https://github.com/thearctesian/omnixy/stargazers)
```

## 🎯 Final Checklist

Before announcing publicly:

- [ ] Repository is public
- [ ] All documentation is complete
- [ ] install.sh works correctly
- [ ] URLs are correct in all files
- [ ] License file is present
- [ ] GitHub Actions workflow passes
- [ ] README has clear installation instructions
- [ ] Screenshots added (optional)
- [ ] Release created
- [ ] Repository has description and topics

## 🚀 You're Ready!

Your configuration is now ready for the world to use!

### Quick Commands for Users

```bash
# Installation
curl -fsSL https://raw.githubusercontent.com/YOUR-USERNAME/YOUR-REPO-NAME/main/install.sh | bash

# Direct flake usage
sudo nixos-rebuild switch --flake github:YOUR-USERNAME/YOUR-REPO-NAME#home
```

## 📞 Support

Set up support channels:
1. GitHub Issues for bugs
2. GitHub Discussions for questions
3. Discord/Matrix for community chat (optional)

---

**Congratulations on your deployment! 🎉**
