{ pkgs, lib, ... }:{
  services.xserver = {
    videoDrivers = ["displaylink" "modesetting"];
    displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.randr}/bin/xrandr --setprovideroutputsource 2 0
    '';
  };
}
