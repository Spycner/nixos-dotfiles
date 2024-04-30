{
  self,
  inputs,
  ...
}: let
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    # main pc
    "pkraus@athena" = [
      ../.
      ./athena
    ];

    # laptop
    "pkraus@persephone" = [
      ../.
      ./persephone
    ];

  };

  inherit (inputs.home-manager.lib) homeManagerConfiguration;

  system = "x86_64-linux";

  pkgs = inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "pkraus_athena" = homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = homeImports."pkraus@athena";
      };

      "pkraus_persephone" = homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = homeImports."pkraus@persephone";
      };
    };
  };
}
