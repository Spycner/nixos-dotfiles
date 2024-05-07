let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix
    ./hardware/fwupd.nix
    ./hardware/bluetooth.nix


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
