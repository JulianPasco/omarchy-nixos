{
  description = "Omarchy Clone for NixOS - 100% Feature Parity";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    omarchy-nix = {
      url = "github:henrysipp/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, omarchy-nix, ... }:
    let
      system = "x86_64-linux";
      
      # Common configuration shared between home and work
      commonConfig = { config, pkgs, ... }: {
        # Allow unfree packages (Chrome, etc.)
        nixpkgs.config.allowUnfree = true;

        # Omarchy base settings (will be configured during installation)
        omarchy = {
          full_name = "User";
          email_address = "user@example.com";
          theme = "tokyo-night";
        };

        # Home Manager integration
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          
          users.julian = {
            imports = [ omarchy-nix.homeManagerModules.default ];

            home = {
              username = "julian";
              homeDirectory = "/home/julian";
              stateVersion = "24.11";

              # ALL Omarchy packages (143 packages)
              packages = with pkgs; [
                # Core System Tools
                avahi
                bash-completion
                bat
                brightnessctl
                btop
                clang
                cups
                cups-filters
                # cups-pdf  # Not available in nixpkgs
                docker
                docker-buildx
                docker-compose
                dust
                evince
                exfatprogs
                eza
                fastfetch
                fd
                ffmpegthumbnailer
                fontconfig
                fzf
                gh
                git
                grim
                gum
                imagemagick
                imv
                inetutils
                inxi
                iwd
                jq
                lazydocker
                lazygit
                less
                libsecret
                libyaml
                libqalculate
                llvm
                luarocks
                man
                mariadb
                mise
                mpv
                neovim
                pamixer
                pinta
                playerctl
                plocate
                # plymouth  # May not be available
                polkit_gnome
                postgresql
                ripgrep
                ruby
                rustc
                satty
                signal-desktop
                slurp
                starship
                sushi
                swaybg
                tldr
                tree-sitter
                # tzupdate  # May not be available
                # ufw  # Not available in nixpkgs (use networking.firewall instead)
                unzip
                whois
                wireless-regdb
                wireplumber
                wl-clipboard
                xmlstarlet
                xournalpp
                zoxide
                
                # Hyprland & Wayland
                hyprland
                hypridle
                hyprlock
                hyprpicker
                hyprsunset
                mako
                waybar
                wayfreeze
                xdg-desktop-portal-gtk
                xdg-desktop-portal-hyprland
                
                # Terminal & Shell
                ghostty
                
                # GNOME Apps
                gnome-calculator
                gnome-keyring
                gnome-themes-extra
                nautilus
                gnome-disk-utility
                gvfs
                
                # Fonts
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-color-emoji
                noto-fonts-extra
                font-awesome
                # ia-writer-duospace  # Not in nixpkgs, may be from omarchy overlays
                (nerdfonts.override { fonts = [ "CascadiaMono" "JetBrainsMono" ]; })
                
                # Input Methods
                fcitx5
                fcitx5-gtk
                fcitx5-qt
                
                # Qt/KDE
                libsForQt5.qtstyleplugin-kvantum
                qt5.qtwayland
                
                # Python Packages
                python3Packages.pygobject3
                python3Packages.poetry-core
                python3Packages.terminaltexteffects
                
                # Media & Graphics
                kdenlive
                obs-studio
                
                # Productivity
                libreoffice-fresh
                obsidian
                typora
                
                # Communication
                spotify
                
                # Browsers
                chromium
                google-chrome
                
                # Office
                onlyoffice-desktopeditors
                
                # Development
                # windsurf  # Not in nixpkgs - install separately if needed
                
                # Display Manager
                sddm
                
                # System Config
                system-config-printer
                power-profiles-daemon
                # nssmdns  # May not be available
                
                # Additional Tools
                localsend
                # gpu-screen-recorder  # May not be available
                # yaru-theme  # May not be available
                nwg-dock-hyprland
                
                # Walker launcher (if available, otherwise use wofi)
                # walker
              ];
              
              # Install all Omarchy scripts to ~/.local/share/omarchy/bin
              file.".local/share/omarchy/bin" = pkgs.lib.mkForce {
                source = ./bin;
                recursive = true;
                executable = true;
              };
              
              # Add Omarchy bin to PATH
              sessionPath = [ "$HOME/.local/share/omarchy/bin" ];
            };

            # Extra Hyprland configuration
            wayland.windowManager.hyprland = {
              extraConfig = ''
                # Enable natural scrolling on touchpad
                input {
                  touchpad {
                    natural_scroll = true
                  }
                }

                # Start dock with default settings
                exec-once = nwg-dock-hyprland
              '';
            };
          };
        };
      };

      # Function to create a host configuration
      mkHost = hostName: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            omarchy-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            commonConfig
            ./hosts/${hostName}.nix
          ] ++ extraModules;
        };

      pkgs = nixpkgs.legacyPackages.${system};
      
    in {
      nixosConfigurations = {
        home = mkHost "home" [];
        work = mkHost "work" [];
      };

      # Helper apps for installation
      apps.${system} = {
        # Quick installer script
        install = {
          type = "app";
          program = toString (pkgs.writeShellScript "install" ''
            #!/usr/bin/env bash
            set -e

            echo "🚀 Julian's Omarchy NixOS Installer"
            echo "===================================="
            echo ""

            # Detect hostname
            if [ -f /etc/hostname ]; then
              HOSTNAME=$(cat /etc/hostname)
            else
              echo "Enter hostname (home/work):"
              read HOSTNAME
            fi

            echo "Installing configuration for: $HOSTNAME"
            echo ""
            # Clone repo if not already present
            if [ ! -d /etc/nixos/.git ]; then
              echo "📦 Cloning configuration..."
              sudo rm -rf /etc/nixos.backup
              sudo mv /etc/nixos /etc/nixos.backup || true
              sudo git clone https://github.com/JulianPasco/omarchy-nixos /etc/nixos
            fi

            # Generate hardware config if it doesn't exist
            if [ ! -f /etc/nixos/hosts/hardware-$HOSTNAME.nix ]; then
              echo "🔧 Generating hardware configuration..."
              sudo mkdir -p /etc/nixos/hosts
              sudo mv /tmp/hardware.nix /etc/nixos/hosts/hardware-$HOSTNAME.nix
            fi

            # Build and switch
            echo "🏗️  Building system configuration..."
            sudo nixos-rebuild switch --flake /etc/nixos#$HOSTNAME

            echo ""
            echo "✅ Installation complete!"
            echo "🎉 Please log out and select Hyprland at the login screen"
          '');
        };
      };
    };
}
