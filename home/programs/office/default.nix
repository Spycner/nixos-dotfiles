{pkgs, ...}: {
  imports = [
    ./zathura.nix
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
