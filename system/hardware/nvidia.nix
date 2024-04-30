{
  pkgs,
  config,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  environment.variables = {
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  hardware = {
    nvidia = {
      # driver - choose either stable, beta or production
      # open = true; # open-source driver currently in alpha, not recommended
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # modesetting is required
      modesetting.enable = true;

      powerManagement.enable = false;
      # Experimental: can turn gpu off if not in use
      powerManagement.finegrained = false;

      # enable nvidia-settings menue
      nvidiaSettings = true;
    };
    opengl.extraPackages = with pkgs; [nvidia-vaapi-driver];
  };

  virtualisation.docker.enableNvidia = true;
  systemd.enableUnifiedCgroupHierarchy = false;
}
