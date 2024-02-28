{
  imports = [
    # host config
    ../../../hosts/athena

    # neovim config for editing
    ../../editors/neovim

    # terminal emulator
    ../../terminal/emulators/alacritty

    # programs
    ../../programs
    ../../programs/games
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
  ];
}