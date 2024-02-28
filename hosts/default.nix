{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") desktop laptop;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    athena = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./athena
          "${mod}/core/lanzaboote.nix"

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/hyprland.nix"
          "${mod}/programs/steam.nix"

          "${mod}/network/spotify.nix"
          "${mod}/network/syncthing.nix"

          "${mod}/services/kmonad"
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"

          {
            home-manager = {
              users.mihai.imports = homeImports."pkraus@athena";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
