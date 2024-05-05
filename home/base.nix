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
    html.enable = true;
    json.enable = true;
    manpages.enable = true;
  };
  programs.home-manager.enable = true;
}
