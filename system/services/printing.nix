{ pkgs, ... }:{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      hplip 
      hplipWithPlugin
    ];
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    openFirewall = true;
    defaultShared = true;
  };

#  hardware.printers = {
#    ensurePrinters = [
#      {
#        name = "HP ENVY 5540";
#        location = "Home";
#        deviceUri = "http://192.168.178.26";
#        ppdOptions = {
#          PageSize  = "A4";
#        };
#      }
#    ];
#  };
}
