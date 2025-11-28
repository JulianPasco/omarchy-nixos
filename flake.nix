{
  description = "Omarchy Clone for NixOS - close to Omarchy, but actually builds";

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

      pkgs = nixpkgs.legacyPackages.${system};

      # Common configuration shared between home and work
      commonConfig = { config, pkgs, ... }: {
        # Allow unfree packages (Chrome, 1Password, etc)
        nixpkgs.config.allowUnfree = true;

        # Omarchy base settings (the install script or host files can override these)
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
            imports = [
              omarchy-nix.homeManagerModules.default
            ];

            home = {
              username = "julian";
              homeDirectory = "/home/julian";
              stateVersion = "24.11";

              # Omarchy style app set, trimmed so it actually exists on NixOS
              packages = with pkgs; [
                # Core System Tools (user facing)
                _1password-gui
                _1password-cli
                bash-completion
                bat
                brightnessctl
                btop
                clang
                cups
                cups-filters
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
                # neovim  # Provided by omarchy-nix.homeManagerModules.default
                pamixer
                pinta
                playerctl
                plocate
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
                unzip
                whois
                wireless-regdb
                wireplumber
                wl-clipboard
                xmlstarlet
                xournalpp
                zoxide

                # Hyprland & Wayland bits (most provided by omarchy-nix)
                # hyprland  # Provided by omarchy-nix
                # hypridle  # Provided by omarchy-nix
                # hyprlock  # Provided by omarchy-nix
                # hyprpicker  # Provided by omarchy-nix
                # hyprsunset  # Provided by omarchy-nix
                # mako  # Provided by omarchy-nix
                # waybar  # Provided by omarchy-nix
                wayfreeze
                xdg-desktop-portal-gtk
                # xdg-desktop-portal-hyprland  # Provided by omarchy-nix

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
                font-awesome
                # ia-writer-duospace  # Not in nixpkgs
                nerd-fonts.caskaydia-mono
                nerd-fonts.jetbrains-mono

                # Input Methods (base)
                fcitx5
                fcitx5-gtk
                # libsForQt5.fcitx5-qt   # Known to cause undefined attr issues on your setup

                # Qt/KDE utils
                libsForQt5.qtstyleplugin-kvantum
                qt5.qtwayland

                # Python Packages
                python3Packages.pygobject3
                python3Packages.poetry-core
                # python3Packages.terminaltexteffects  # Not available on all nixpkgs revisions

                # Media & Graphics
                # libsForQt5.kdenlive   # Missing in your nixpkgs, remove for now
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
                windsurf

                # Display Manager package is not needed here
                # configure SDDM in NixOS modules instead of home.packages
                # libsForQt5.sddm

                # System Config tools
                system-config-printer
                power-profiles-daemon
                # nssmdns  # not needed, handled via services in NixOS

                # Additional Tools
                localsend
                # gpu-screen-recorder  # not in nixpkgs on your revision
                # yaru-theme           # same story, theming should be handled differently

                # App launcher (Walker) is provided by omarchy-nix
                # SUPER + SPACE to launch apps
              ];

              # Install Omarchy scripts to ~/.local/share/omarchy/bin
              file.".local/share/omarchy/bin" = pkgs.lib.mkForce {
                source = ./bin;
                recursive = true;
                executable = true;
              };

              # Install Omarchy default configs (waybar indicators, etc.)
              file.".local/share/omarchy/default" = {
                source = ../omarchy/default;
                recursive = true;
              };

              # Add Omarchy bin to PATH
              sessionPath = [ "$HOME/.local/share/omarchy/bin" ];

              # Set OMARCHY_PATH environment variable
              sessionVariables = {
                OMARCHY_PATH = "$HOME/.local/share/omarchy";
              };
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
              '';
            };

            # Disable omarchy-nix waybar config and use our own
            programs.waybar.enable = pkgs.lib.mkForce false;
            
            # Override omarchy-nix waybar directory (it uses home.file not xdg.configFile)
            home.file.".config/waybar/".source = pkgs.lib.mkForce (pkgs.runCommand "waybar-config" {} ''
              mkdir -p $out
              cp ${./waybar-config.jsonc} $out/config
              cp ${../omarchy/config/waybar/style.css} $out/style.css
            '');
            
            # Manually enable waybar as a systemd service
            systemd.user.services.waybar = {
              Unit = {
                Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
                PartOf = [ "graphical-session.target" ];
                After = [ "graphical-session.target" ];
              };
              Service = {
                ExecStart = "${pkgs.waybar}/bin/waybar";
                Restart = "on-failure";
              };
              Install = {
                WantedBy = [ "hyprland-session.target" ];
              };
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

    in {
      nixosConfigurations = {
        home = mkHost "home" [];
        work = mkHost "work" [];
      };

      # Helper apps for installation
      apps.${system} = {
        install = {
          type = "app";
          program = toString (pkgs.writeShellScript "install" ''
            #!/usr/bin/env bash
            set -e

            echo "Julian's Omarchy NixOS Installer"
            echo "================================"
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
              echo "Cloning configuration into /etc/nixos..."
              sudo rm -rf /etc/nixos.backup
              sudo mv /etc/nixos /etc/nixos.backup || true
              sudo git clone https://github.com/JulianPasco/omarchy-nixos /etc/nixos
            fi

            # Generate hardware config if it does not exist
            if [ ! -f /etc/nixos/hosts/hardware-$HOSTNAME.nix ]; then
              echo "Generating hardware configuration..."
              sudo mkdir -p /etc/nixos/hosts
              sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix
              sudo mv /tmp/hardware.nix /etc/nixos/hosts/hardware-$HOSTNAME.nix
            fi

            # Build and switch
            echo "Building system configuration..."
            sudo nixos-rebuild switch --flake /etc/nixos#$HOSTNAME

            echo ""
            echo "Installation complete."
            echo "Log out and choose Hyprland from the login screen."
          '');
        };
      };
    };
}
