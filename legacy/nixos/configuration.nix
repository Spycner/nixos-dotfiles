# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  # enable flakes for system
  nix.settings = {
    # enable flakes and nix command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
    ];

  # allow unfree packages for nvidia drivers
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-25.9.0" # for spotify / obsidian
    ];
  };

  home-manager = {
   extraSpecialArgs = { inherit inputs; };
   users = {
    pkraus = import ../home-manager/home.nix;
   };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    # enable = true; 
  };
  
  # change keyboard layout to german
	  console.keyMap = "de";  

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  # Bluetooth setup
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pkraus = {
    isNormalUser = true;
    description = "pkraus";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    lf
    tmux
    zsh
    home-manager
    git
    unzip
    # nvidia-offload
 
    # hyprland packages
    waybar
    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    )
    dunst
    libnotify
    pipewire # screensharing and sound
    wireplumber # helper for pipewire
    hyprpaper # wallpaper daemon
    alacritty # terminal emulator
    rofi-wayland # app launcher
    dolphin
    brave
    cliphist
    wl-clip-persist

    # other software
    spotify
    obsidian
  ];

  # xdg config for hyprland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # set neovim to default editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # set zsh to default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  ### nvidia setup ###
  # enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # driver - choose either stable, beta or production
    open = true; # open-source driver currently in alpha, not recommended
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    # modesetting is required
    modesetting.enable = true;
    
    prime = {
      nvidiaBusId = "PCI:8.0.0";
    };
    # Nvidia power management, experimental and may cause sleep/suspend to fail. <- trying since I don't really want suspend or sleep
    powerManagement.enable = false;
    # Experimental: can turn gpu off if not in use
    powerManagement.finegrained = false;
    
    # enable nvidia-settings menue
    nvidiaSettings = true;
  };

  # Enable hyprland on NixOS
  programs.hyprland = {
    enable = true;
    # nvidiaPatches = true; Disabled, cli said it's no longer needed
    xwayland.enable = true;
  };

  # Set variables for hyprland
  environment.sessionVariables = {
    # if cursor becomes invisible <- preemtivly set to true
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
}
