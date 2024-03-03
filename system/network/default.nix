{lib, ...}:
# networking configuration
{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services = {
    openssh = {
      enable = true;
      settings.UseDns = true;
    };

    # DNS resolver
    resolved.enable = true;
  };

}
