{pkgs, ...}: {
  imports = [
    ./zathura.nix
    ./conferencing.nix
  ];

  home.packages = with pkgs; [
    libreoffice
    obsidian
    xournalpp
    betterbird
    discord
    onedrive
    onedrivegui
    zoomus
  ];
}
