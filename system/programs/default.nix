{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
    ./docker.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
  };
}
