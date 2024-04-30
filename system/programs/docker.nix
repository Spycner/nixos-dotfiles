{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  home.packages = with pkgs; [ 
    docker-compose 
  ];
}
