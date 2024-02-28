# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../system/hardware/nvidia.nix
    ];

  networking.hostName = "athena"; # Define your hostname.
  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "";
    # enable = true; 
  };
  
  # change keyboard layout to german
	console.keyMap = "de";
}