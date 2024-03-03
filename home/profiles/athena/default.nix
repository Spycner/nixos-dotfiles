{
  imports = [
    # neovim config for editing
    ../../editors/neovim
    ../../editors/vscode

    # terminal emulator
    ../../terminal/emulators/alacritty.nix

    # programs
    ../../programs
    ../../programs/wayland

    # media services
    ../../services/media/playerctl.nix
    ../../services/media/spotifyd.nix

    # system services
    ../../services/system/dunst.nix
    ../../services/system/polkit-agent.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    ../../services/wayland/waybar.nix
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,1920x1080@144,auto,auto"
    "HDMI-A-1,1920x1080@60,auto,auto"
  ];
}
