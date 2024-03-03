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
    inherit (import "${self}/system") desktop;

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
          {
            home-manager = {
              users.pkraus.imports = homeImports."pkraus@athena";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
