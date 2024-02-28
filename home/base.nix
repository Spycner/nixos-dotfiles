{inputs, ...}: {
  imports = [
    inputs.nix-index-db.hmModules.nix-index
    ./terminal/shell
  ];

  home = {
    username = "pkraus";
    homeDirectory = "/home/pkraus";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  programs.home-manager.enable = true;
}
