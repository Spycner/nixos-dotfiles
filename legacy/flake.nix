{
  description = "My basic system setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x84_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = {
        allowUnfree =  true;
      };
    };
  in
  {
    nixosConfigurations = {
      pkraus = nixpkgs.lib.nixosSystem{
        specialArgs = { inherit inputs system; };

	modules = [
	  ./nixos/configuration.nix
	];
      };
    };
  };
}
