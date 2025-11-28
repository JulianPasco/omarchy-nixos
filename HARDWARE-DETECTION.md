# Hardware Detection Guide

This guide helps you gather hardware information needed for your NixOS configuration.

## 🔍 Automatic Detection

The installer script automatically detects most hardware, but you may need to manually configure some settings.

## 📋 Commands to Run on Your System

### Basic System Information

```bash
# System overview
inxi -Fxz

# Or if inxi not available
nix-shell -p inxi --run "inxi -Fxz"
```

### CPU Information

```bash
# CPU details
lscpu

# CPU model
cat /proc/cpuinfo | grep "model name" | head -1
```

### Graphics Card

```bash
# List graphics cards
lspci | grep -i vga
lspci | grep -i 3d

# For NVIDIA
lspci | grep -i nvidia

# For AMD
lspci | grep -i amd
```

### Storage Devices

```bash
# List all block devices
lsblk

# Detailed disk information
sudo fdisk -l

# Show UUIDs
ls -l /dev/disk/by-uuid/

# Show partition labels
ls -l /dev/disk/by-label/
```

### LUKS Encryption

```bash
# Find LUKS devices
sudo blkid | grep crypto_LUKS

# Get LUKS UUID
sudo cryptsetup luksDump /dev/nvme0n1p2 | grep UUID

# Check LUKS status
sudo cryptsetup status /dev/mapper/luks-*
```

### Network Hardware

```bash
# Network interfaces
ip link show

# Wireless info
lspci | grep -i network
lspci | grep -i wireless

# Ethernet info
lspci | grep -i ethernet
```

### Audio Hardware

```bash
# Audio devices
lspci | grep -i audio

# ALSA info
aplay -l
```

### USB Devices

```bash
# List USB devices
lsusb

# Detailed USB info
lsusb -v
```

### Monitor Information

```bash
# List connected displays (in Hyprland)
hyprctl monitors

# Or using xrandr (if available)
xrandr --query

# Get EDID information
sudo get-edid | parse-edid
```

## 📝 Configuration Examples

### For NVIDIA Graphics

If you have NVIDIA GPU, add to your `hosts/home.nix` or `hosts/work.nix`:

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
```

### For AMD Graphics

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  # AMD drivers
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };
}
```

### For Intel Graphics

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  # Intel drivers
  services.xserver.videoDrivers = [ "modesetting" ];
  
  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
```

### For Laptop Touchpad

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  # Touchpad support
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };
}
```

### For Bluetooth

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  
  services.blueman.enable = true;
}
```

### For WiFi

Most WiFi cards work out of the box, but if you have issues:

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  # Enable firmware
  hardware.enableRedistributableFirmware = true;
  
  # For specific WiFi cards (example: Intel)
  boot.extraModulePackages = with config.boot.kernelPackages; [
    # Add specific drivers if needed
  ];
}
```

### For Multiple Monitors

Add to your `flake.nix` in the `omarchy` section:

```nix
omarchy = {
  # ... other settings ...
  
  monitors = [
    # Format: "NAME,WIDTHxHEIGHT@REFRESH,X_OFFSET x Y_OFFSET,SCALE"
    "DP-1,2560x1440@144,0x0,1"
    "HDMI-1,1920x1080@60,2560x0,1"
  ];
  
  scale = 1;  # or 2 for HiDPI displays
};
```

### For LUKS Encryption

After finding your LUKS UUID with `sudo blkid | grep crypto_LUKS`:

```nix
{ config, pkgs, ... }:

{
  # ... other config ...

  boot.initrd.luks.devices."luks-root" = {
    device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
    preLVM = true;
    allowDiscards = true;  # For SSD TRIM support
  };
}
```

## 🖥️ Getting Information from Work PC

If you're setting this up and need to get information from your work PC, run these commands and copy the output:

### Essential Information Script

Save this as `get-hardware-info.sh` and run it on your work PC:

```bash
#!/usr/bin/env bash

echo "=== SYSTEM INFORMATION ==="
echo ""

echo "--- CPU ---"
lscpu | grep "Model name"
echo ""

echo "--- Graphics Card ---"
lspci | grep -i vga
lspci | grep -i 3d
echo ""

echo "--- Storage ---"
lsblk
echo ""

echo "--- LUKS Encryption ---"
sudo blkid | grep crypto_LUKS
echo ""

echo "--- Network ---"
ip link show
echo ""

echo "--- Audio ---"
lspci | grep -i audio
echo ""

echo "--- Full Hardware Config ---"
sudo nixos-generate-config --show-hardware-config
```

Run it:
```bash
chmod +x get-hardware-info.sh
./get-hardware-info.sh > my-hardware-info.txt
```

Then copy `my-hardware-info.txt` to use in your configuration.

## 🔧 Testing Hardware Configuration

After updating your configuration, test it:

```bash
# Build without switching
sudo nixos-rebuild build --flake /etc/nixos#work

# If successful, switch
sudo nixos-rebuild switch --flake /etc/nixos#work
```

## 📞 Need Help?

If you're unsure about your hardware configuration:

1. Run the commands above
2. Save the output
3. Check the [TROUBLESHOOTING.md](TROUBLESHOOTING.md) guide
4. Ask in [NixOS Discourse](https://discourse.nixos.org/)

---

**Tip**: The installer automatically generates most of this, but manual tweaking may be needed for optimal performance.
