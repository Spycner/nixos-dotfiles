{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/ref=nixos-unstable";
    
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-colors.url = "github:misterio77/nix-colors";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ...}@inputs:
  let
    inherit (self) outputs;
   
    lib = nixpkgs.lib // home-manager.lib;

    system = "x84_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      
      config.allowUnfree = true;
    };
  in
  {
    inherit lib;
    
    nixosConfigurations = {
      # Main Desktop
      athena = lib.nixosSystem{
      };
    };
  };
}
