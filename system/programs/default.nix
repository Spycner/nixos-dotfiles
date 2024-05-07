{
  imports = [
    ./fonts.nix
    ./home-manager.nix
    ./xdg.nix
  ];

  programs = {
    # make HM-managed GTK stuff work
    dconf.enable = true;

    kdeconnect.enable = true;

    seahorse.enable = true;
    
    # enable dynamically linked binaries for python etc.
    nix-ld.enable = true;
  };
  
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
}
