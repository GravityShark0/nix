{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-epub-thumbnailer
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.freon
    gnomeExtensions.pop-shell
    gnomeExtensions.run-or-raise
    gnomeExtensions.caffeine
    # gnomeExtensions.blur-my-shell
  ];
  # Gnome settings
  dconf.settings = {
    "org/gnome/desktop/session".idle-delay = 300;
    "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
    "org/gnome/desktop/wm/preferences".focus-mode = "sloppy";
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>w" ];
      toggle-maximized = [ "<Super>f" ];
      maximize = [ "" ];
      unmaximize = [ "" ];
      switch-group = [ "" ];
      switch-group-backward = [ "" ];
    };
    "org/gnome/desktop/interface" = {
      enable-hot-corners = true;
      color-scheme = "default";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-saver-profile-on-low-battery = true;
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-battery-timeout = 900;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 900;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
      workspaces-only-on-primary = true;
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-right = [ "" ];
      toggle-tiled-left = [ "" ];
    };

    "org/gnome/shell" = {
      # "app-switcher".current-workspace-only = false;
      disable-user-extensions = false;
      # `gnome-extensions list` for a list
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "freon@UshakovVasilii_Github.yahoo.com"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "pop-shell@system76.com"
        "run-or-raise@edvard.cz"
        "caffeine@patapon.info"
        # "blur-my-shell@aunetx"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      show-trash = false;
      hot-keys = true;
      shortcut = [ "<Super>grave" ];
      shortcut-text = "<Super>grave";
    };
    "org/gnome/shell/extensions/pop-shell" = {
      tile-by-default = true;
      active-hint = true;
      hint-color-rgba = "rgba(196, 167, 231, 255)";
    };
  };
}
