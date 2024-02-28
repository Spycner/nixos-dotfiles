let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix

    ./network/avahi.nix
    ./network/default.nix
    ./network/tailscale.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
    ./hardware/bluetooth.nix
  ];

  laptop =
    desktop
    ++ [
      ./services/backlight.nix
      ./services/power.nix
    ];
in {
  inherit desktop laptop;
}
