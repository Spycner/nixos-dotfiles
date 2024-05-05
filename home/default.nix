{
  lib,
  self,
  inputs,
  ...
}: {
  imports = [
    ./themespec.nix
    ./terminal
    ./base.nix
    ./development.nix
    inputs.matugen.nixosModules.default
    inputs.hyprlock.homeManagerModules.default
    # inputs.hypridle.homeManagerModules.default
    self.nixosModules.theme
  ];

  nixpkgs.overlays = [
    (_final: prev: {
      lib = prev.lib // {colors = import "${self}/lib/colors" lib;};
    })
  ];
}
