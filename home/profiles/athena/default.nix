{
  imports = [
    # editors
    ../../editors/neovim

    # programs
    ../../programs
    ../../programs/wayland

    # services
    ../../services/ags
    ../../services/cinny.nix

    # media services
    ../../services/media/playerctl.nix
    ../../services/media/spotifyd.nix

    # system services
    ../../services/system/dunst.nix
    ../../services/system/kdeconnect.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix
    ../../services/system/syncthing.nix
    ../../services/system/udiskie.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix

    # terminal emulators
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm.nix
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
        "DP-1,1920x1080@144,auto,auto"
        "HDMI-A-1,1920x1080@60,auto,auto"
    ];
  };
}
