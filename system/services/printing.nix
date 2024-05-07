{
  services.printing = {
    enable = true;
    drivers = [
      hplip 
      hplipWithPlugin
    ];
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP ENVY 5540";
        location = "Home";
        deviceUri = "http://192.168.178.26";
        ppdOptions = {
          PageSize  = "A4";
        };
      };
    ];
  };
}
