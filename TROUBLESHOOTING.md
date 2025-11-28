# Troubleshooting Guide

## 🔧 Common Issues and Solutions

### Installation Issues

#### "Command not found: git"
**Problem**: Git is not installed on the fresh NixOS system.

**Solution**:
```bash
sudo nix-env -iA nixos.git
```

#### "Permission denied" during installation
**Problem**: Running the script as root.

**Solution**: Run as your normal user (the script uses sudo when needed):
```bash
curl -fsSL https://raw.githubusercontent.com/thearctesian/omnixy/main/install.sh | bash
```

#### Build fails with "error: getting status of '/etc/nixos/hosts/hardware-*.nix'"
**Problem**: Hardware configuration file is missing.

**Solution**: Generate it manually:
```bash
sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix
sudo mkdir -p /etc/nixos/hosts
sudo mv /tmp/hardware.nix /etc/nixos/hosts/hardware-home.nix
```

### Boot Issues

#### System won't boot after installation
**Problem**: LUKS UUID not configured correctly.

**Solution**:
1. Boot from NixOS USB
2. Mount your system:
   ```bash
   sudo cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
   sudo mount /dev/mapper/cryptroot /mnt
   sudo mount /dev/nvme0n1p1 /mnt/boot
   ```
3. Find correct UUID:
   ```bash
   sudo blkid | grep crypto_LUKS
   ```
4. Edit configuration:
   ```bash
   sudo nano /mnt/etc/nixos/hosts/home.nix
   ```
5. Add LUKS device:
   ```nix
   boot.initrd.luks.devices."luks-root".device = "/dev/disk/by-uuid/YOUR-UUID";
   ```
6. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake /mnt/etc/nixos#home
   ```

#### "Kernel panic" on boot
**Problem**: Missing kernel modules in initrd.

**Solution**: Add required modules to your hardware configuration:
```nix
boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
```

### Hyprland Issues

#### Hyprland option missing at login screen
**Problem**: Display manager not configured properly.

**Solution**: Check if display manager is enabled:
```bash
systemctl status display-manager
```

If not running, check your configuration includes display manager setup from omarchy-nix.

#### Black screen after logging into Hyprland
**Problem**: Graphics drivers not loaded.

**Solution**:
1. Check graphics card:
   ```bash
   lspci | grep VGA
   ```

2. For NVIDIA, add to your host config:
   ```nix
   services.xserver.videoDrivers = [ "nvidia" ];
   hardware.nvidia.modesetting.enable = true;
   ```

3. For AMD:
   ```nix
   services.xserver.videoDrivers = [ "amdgpu" ];
   ```

4. Rebuild:
   ```bash
   sudo nixos-rebuild switch --flake /etc/nixos#home
   ```

#### Hyprland crashes immediately
**Problem**: Check logs for specific error.

**Solution**:
```bash
# View Hyprland logs
journalctl -u display-manager -b

# Try starting manually to see errors
Hyprland
```

### Network Issues

#### No WiFi networks showing
**Problem**: NetworkManager not running.

**Solution**:
```bash
# Check status
systemctl status NetworkManager

# Start if not running
sudo systemctl start NetworkManager

# Enable at boot
sudo systemctl enable NetworkManager
```

#### Can't connect to WiFi
**Problem**: WiFi drivers missing.

**Solution**: Add firmware to configuration:
```nix
hardware.enableRedistributableFirmware = true;
```

### Audio Issues

#### No sound output
**Problem**: PipeWire not configured correctly.

**Solution**: Verify PipeWire is running:
```bash
systemctl --user status pipewire
systemctl --user status pipewire-pulse
```

If not running:
```bash
systemctl --user start pipewire
systemctl --user start pipewire-pulse
```

#### Wrong audio device selected
**Problem**: Multiple audio devices.

**Solution**: Use pavucontrol to select:
```bash
nix-shell -p pavucontrol --run pavucontrol
```

### Package Issues

#### "Package not found" error
**Problem**: Package name incorrect or not in nixpkgs.

**Solution**:
```bash
# Search for correct package name
nix search nixpkgs packagename

# Or search online
# https://search.nixos.org/packages
```

#### Build fails with "hash mismatch"
**Problem**: Cached hash is incorrect.

**Solution**:
```bash
# Update flake lock
sudo nix flake update

# Clear cache
sudo nix-store --verify --check-contents --repair
```

### Configuration Issues

#### "Infinite recursion" error
**Problem**: Circular dependency in configuration.

**Solution**: Check your imports and options for circular references. Use `--show-trace`:
```bash
sudo nixos-rebuild build --flake /etc/nixos#home --show-trace
```

#### "Option does not exist" error
**Problem**: Trying to use an option that doesn't exist.

**Solution**:
```bash
# Search for correct option name
nixos-option services.xserver

# Check NixOS options online
# https://search.nixos.org/options
```

#### Changes not taking effect
**Problem**: Not rebuilding after changes.

**Solution**: Always rebuild after editing configuration:
```bash
sudo nixos-rebuild switch --flake /etc/nixos#home
```

### Performance Issues

#### System is slow after installation
**Problem**: Building packages from source.

**Solution**: Enable binary cache:
```nix
nix.settings = {
  substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
};
```

#### High disk usage
**Problem**: Old generations not cleaned.

**Solution**:
```bash
# Remove old generations
sudo nix-collect-garbage -d

# Optimize store
sudo nix-store --optimize
```

### Display Issues

#### Wrong resolution or scaling
**Problem**: Monitor configuration not set.

**Solution**: Add to flake.nix:
```nix
omarchy = {
  monitors = [ "eDP-1,1920x1080@60,0x0,1" ];
  scale = 1;  # or 2 for HiDPI
};
```

#### Multiple monitors not working
**Problem**: Monitor configuration needed.

**Solution**:
```nix
omarchy = {
  monitors = [
    "DP-1,2560x1440@144,0x0,1"
    "HDMI-1,1920x1080@60,2560x0,1"
  ];
};
```

### Update Issues

#### "Flake lock file is out of date"
**Problem**: Lock file needs updating.

**Solution**:
```bash
cd /etc/nixos
sudo nix flake update
sudo nixos-rebuild switch --flake .#home
```

#### Update breaks system
**Problem**: New version has breaking changes.

**Solution**: Rollback to previous generation:
```bash
sudo nixos-rebuild switch --rollback
```

## 🆘 Emergency Recovery

### System Won't Boot

1. **Boot from NixOS USB**
2. **Mount your system**:
   ```bash
   sudo mount /dev/mapper/cryptroot /mnt  # or your root partition
   sudo mount /dev/nvme0n1p1 /mnt/boot    # or your boot partition
   ```
3. **Chroot into system**:
   ```bash
   sudo nixos-enter --root /mnt
   ```
4. **Rollback to previous generation**:
   ```bash
   nix-env --list-generations --profile /nix/var/nix/profiles/system
   nix-env --switch-generation <number> --profile /nix/var/nix/profiles/system
   /nix/var/nix/profiles/system/bin/switch-to-configuration boot
   ```
5. **Reboot**:
   ```bash
   exit
   sudo reboot
   ```

### Complete System Reset

If all else fails, reinstall:
```bash
# Backup your data first!
# Then run the installer again
curl -fsSL https://raw.githubusercontent.com/thearctesian/omnixy/main/install.sh | bash
```

## 📞 Getting Help

### Check Logs
```bash
# System logs
journalctl -xe

# Specific service
journalctl -u display-manager

# Boot logs
journalctl -b
```

### Test Configuration
```bash
# Build without switching
sudo nixos-rebuild build --flake /etc/nixos#home

# Show detailed errors
sudo nixos-rebuild build --flake /etc/nixos#home --show-trace
```

### Community Resources

- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [r/NixOS](https://www.reddit.com/r/NixOS/)
- [NixOS Matrix Chat](https://matrix.to/#/#nixos:nixos.org)

### Report Issues

If you find a bug in this configuration:
1. Check existing issues: https://github.com/thearctesian/omnixy/issues
2. Create a new issue with:
   - Your hardware info
   - Error messages
   - Steps to reproduce
   - Your configuration (if modified)

---

**Remember**: NixOS is declarative - you can always rollback! 🔄
