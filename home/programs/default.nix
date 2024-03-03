{pkgs, ...}: {
  imports = [
    ./anyrun
    ./browsers/firefox.nix
    ./media
    ./gtk.nix
    ./office
  ];
}
