{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "pkraus@athena" = [
      ../.
      ./athena
    ];
    "pkraus@persephone" = [
      ../.
      ./rog
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  # we need to pass this to NixOS' HM module
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "pkraus_athena" = homeManagerConfiguration {
        modules = homeImports."pkraus@athena";
        inherit pkgs extraSpecialArgs;
      };

      "pkraus_persephone" = homeManagerConfiguration {
        modules = homeImports."pkras@persephone";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
