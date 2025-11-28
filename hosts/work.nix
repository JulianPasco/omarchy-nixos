{ config, pkgs, ... }:

{
  imports = [
    ./hardware-work.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS encryption is auto-configured in hardware-work.nix by nixos-generate-config

  # Networking
  networking.hostName = "work";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "Africa/Johannesburg";
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Enable printing
  services.printing.enable = true;

  # Audio - PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account (will be configured during installation)
  users.users.julian = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" ];
    # Set initial password (change after first login)
    initialPassword = "changeme";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System version
  system.stateVersion = "24.11";
}
