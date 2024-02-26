{
  pkgs,
  self,
  inputs,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

  age.secrets.spotify = {
    file = "${self}/secrets/spotify.age";
    owner = "pkraus";
    group = "users";
  };
  
  environment.systemPackages = [pkgs.scx];

  hardware = {
    opentabletdriver.enable = true;
    xpadneo.enable = true;
  };

  networking.hostName = "athena";

  security.tpm2.enable = true;

  console.keyMap = "de";

  services = {
    # for SSD/NVME
    fstrim.enable = true;

    # howdy = {
    #   enable = true;
    #   package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
    #   settings = {
    #     core = {
    #       no_confirmation = true;
    #       abort_if_ssh = true;
    #     };
    #     video.dark_threshold = 90;
    #   };
    # };

    # linux-enable-ir-emitter = {
    #   enable = true;
    #   package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    # };

    kmonad.keyboards = {
      io = {
        name = "athena";
        config = builtins.readFile "${self}/system/services/kmonad/main.kbd";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
      };
    };
  };
}