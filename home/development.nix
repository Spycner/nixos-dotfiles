{pkgs, ...}: {
  home.packages = with pkgs; [ 
    docker-compose
    rye
    vscode
  ];
#  programs.nix-ld = {
#    enable = true;
#    libraries = with pkgs; [
#      rye
#    ];
#  };
}
