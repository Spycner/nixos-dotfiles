{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    unrar

    # misc
    libnotify

    # utils
    du-dust
    duf
    fd
    file
    jaq
    ripgrep
    wget
    curl
  ];

  programs = {
    eza.enable = true;
    ssh.enable = true;
  };
}
