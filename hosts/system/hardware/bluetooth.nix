{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
    settings = {
      General = {
        Class = "0x000100";
        ControllerMode = "bredr";
        FastConnectable = true;
        JustWorksRepairing = "always";
        Privacy = "device";
        Enable = "Source,Sink,Media,Socket";
        # Battery info for Bluetooth devices
        Experimental = true;
      };
    };
  };

  # mpris for media control via headset (example)
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # https://github.com/NixOS/nixpkgs/issues/114222
  systemd.user.services.telephony_client.enable = false;
}
