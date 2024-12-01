# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvidia.nix
    ./defaults.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment = {
    systemPackages = [
      # New packages
      pkgs.evolution
      pkgs.doas-sudo-shim
      pkgs.efibootmgr
      pkgs.evince
      pkgs.foot
      pkgs.obs-studio
      pkgs.racket
      pkgs-unstable.home-manager
      pkgs-unstable.mcontrolcenter
      pkgs.wl-clipboard

      # Neovim dependencies
      pkgs.clang-tools
      pkgs.clang
      pkgs.gnumake
      pkgs.go
      pkgs.nodejs
      pkgs.python3
      pkgs.unzip

      # Packages from the past
      pkgs.anki
      pkgs.dash
      pkgs.emacs-gtk
      pkgs.eza
      pkgs.fastfetch
      pkgs.fd
      pkgs.fish
      pkgs.fzf
      pkgs.git
      pkgs.hunspell
      pkgs.joshuto
      pkgs.krita
      # pkgs.libreoffice-fresh
      pkgs.mksh
      pkgs.pass
      pkgs.ripgrep
      pkgs.tmux
      pkgs-unstable.neovim
      pkgs-unstable.wineWowPackages.waylandFull
      pkgs.yt-dlp
      pkgs.ytfzf
      pkgs.zoxide
    ];
    variables = {
      EDITOR = "nvim";
      SYSTEMD_EDITOR = "nvim";
      VISUAL = "nvim";
      GSK_RENDERER = "ngl";
    };
    sessionVariables.NIXOS_OZONE_WL = "1";
    shells = with pkgs; [
      bash
      dash
      mksh
      fish
    ];
    binsh = "${pkgs.dash}/bin/dash";
  };

  # Long live the better posix shell
  users.defaultUserShell = pkgs.mksh;

  # Use doas instead of sudo
  # https://www.reddit.com/r/NixOS/comments/rts8gm/sudo_or_doas/
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "gravity" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  # Vial udev rule
  services.udev.extraRules = ''
    "KERNEL=="hidraw*", 
    SUBSYSTEM=="hidraw", 
    ATTRS{serial}=="*vial:f64c2b3c*", 
    MODE="0660", 
    GROUP="100", 
    TAG+="uaccess", 
    TAG+="udev-acl"'';

  services.flatpak.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # allow it to work with windows time tbh
  time.hardwareClockInLocalTime = true;

  # use zen kernel kuh
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Hosts file
  networking = {
    hosts = {
      "192.168.0.3" = [ "clr" ];
    };
    stevenblack = {
      enable = true;
      block = [
        "gambling"
        "porn"
      ];
    };
  };

  # Optimise package sizes
  nix.optimise.automatic = true;
  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # For somereason /dev/null is NOT being properly permissionisezed
  system.activationScripts.chmod-dev-null.text = ''
    chmod 777 /dev/null
  '';

  # gettin flakey
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
