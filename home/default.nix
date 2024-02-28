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
  ];

  nixpkgs.overlays = [
    (final: prev: {
      lib = prev.lib // {colors = import "${self}/lib/colors" lib;};
    })
  ];
}