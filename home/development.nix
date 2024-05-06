{pkgs, ...}: {
  home.packages = with pkgs; [ 
    docker-compose
    rye
  ];
#  programs.nix-ld = {
#    enable = true;
#    libraries = with pkgs; [
#      rye
#    ];
#  };
}
