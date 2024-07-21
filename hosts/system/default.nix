let
  desktop = [
    ./core/boot.nix
    ./core/default.nix
    ./core/security.nix
    ./core/users.nix

    ./hardware/bluetooth.nix
    ./hardware/fwupd.nix
    ./hardware/opengl.nix

    ./network/default.nix
    ./network/avahi.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
  ];

  laptop =
    desktop
    ++ [
      ./services/power.nix
      ./hardware/displaylink.nix
    ];
in {
  inherit desktop laptop;
}
