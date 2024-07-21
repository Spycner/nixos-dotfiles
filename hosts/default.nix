{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # get the basic config to build on top of
    inherit (import "system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    athena = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./athena

          "${mod}/hardware/nvidia.nix"

          "${mod}/programs/hyprland.nix"

          "${mod}/network/spotify.nix"

          "${mod}/services/gnome-services.nix"
          "${mod}/services/printing.nix"
          {
            home-manager = {
              users.pkraus.imports = homeImports."pkraus@athena";
              extraSpecialArgs = specialArgs;
              backupFileExtension = "bak";
            };
          }

          inputs.chaotic.nixosModules.default
        ];
    };
    persephone = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./persephone

          "${mod}/programs/hyprland.nix"

          "${mod}/network/spotify.nix"

          "${mod}/services/gnome-services.nix"
          "${mod}/services/printing.nix"
          {
            home-manager = {
              users.pkraus.imports = homeImports."pkraus@persephone";
              extraSpecialArgs = specialArgs;
              backupFileExtension = "bak";
            };
          }

          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
