{pkgs, ...}: {
  home.packages = with pkgs; [ 
    docker-compose
  ];
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      rye
    ];
  };
}
