{
  # network discovery, mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true; # Detect printers via UDP 5353
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };
}
