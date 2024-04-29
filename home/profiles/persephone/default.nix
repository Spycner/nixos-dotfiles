{
  imports = [
    # neovim config for editing
    ../../editors/neovim

    # terminal emulator
    ../../terminal/emulators/alacritty.nix
    ../../terminal/emulators/foot.nix
    ../../terminal/emulators/wezterm.nix

    # programs
    ../../programs
    ../../programs/wayland

    # media services
    ../../services/media/playerctl.nix
    ../../services/media/spotifyd.nix

    # system services
    ../../services/system/dunst.nix
    ../../services/system/polkit-agent.nix
    ../../services/system/power-monitor.nix

    # wayland-specific
    ../../services/wayland/hyprpaper.nix
    ../../services/wayland/hypridle.nix
    # ../../services/wayland/waybar.nix
  ];
}
