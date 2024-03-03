let
  desktop = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/opengl.nix

    ./network/default.nix

    ./programs

    ./services
    ./services/greetd.nix
    ./services/pipewire.nix
    ./hardware/bluetooth.nix
  ];
in {
  inherit desktop;
}
