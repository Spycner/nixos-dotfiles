{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pkraus";
  home.homeDirectory = "/home/pkraus";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "pkraus";
    userEmail = "pascal98kraus@gmail.com";
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -la";
      nix-clean = "sudo nix-collect-garbage -d";
      update-pkraus = "sudo nixos-rebuild switch --flake ~/mysystem#pkraus";
      connect-headset = "bluetoothctl connect 00:1B:66:F6:78:EA";
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox)";
    };
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "gruvbox-dark";
    };
  };


  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER"; # windows key
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun -show-icons";
      bind = [
        "$mod, Q, exec, $terminal"
	"$mod, C, killactive,"
	"$mod, M, exit,"
	"$mod, E, exec, $fileManager"
	"$mod, R, exec, $menu"
	"$mod, J, togglesplit,"
	"$mod, left, movefocus, l"
	"$mod, right, movefocus, r"
	"$mod, up, movefocus, u"
	"$mod, down, movefocus, d"
	"$mod, S, togglespecialworkspace, magic"
	"$mod SHIFT, S, movetoworkspace, special:magic"
	"$mod, mouse_down, workspace, e+1"
	"$mod, mouse_up, workspace, e-1"
	"$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
          x: let
	    ws = let
	      c = (x + 1) / 10;
	    in
	      builtins.toString(x + 1 - (c * 10));
	  in [
	    "$mod, ${ws}, workspace, ${toString (x + 1)}"
	    "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
	  ]
	)
	10)
      );
      bindm = [
        "$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindow"
      ];
      env = [
        "XCURSOR_SIZE,24"
	"XCURSOR_THEME,capitaine-cursors-themed"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];
      input = {
        kb_layout = "de";
	follow_mouse  = "1";
	sensitivity = "0"; # 0 -> no modification
      };
      monitor = [
        "DP-1,1920x1080@144,auto,auto"
        "HDMI-A-1,1920x1080@60,auto,auto"
      ];
      general = {
        border_size = "2";
	gaps_in = "5";
	gaps_out = "10";
        "col.active_border" = "rgba(${config.colorScheme.colors.base08}ee) rgba(${config.colorScheme.colors.base0A}ee) 45deg";
	"col.inactive_border" = "rgba(595959aa)";
	cursor_inactive_timeout = "5";
	layout = "dwindle";

	allow_tearing = "false";
      };
      decoration = {
        rounding = "5";
	drop_shadow = "true";
	shadow_range = "4";
	shadow_render_power = "3";
	"col.shadow" = "rgba(1a1a1aee)";
	
	blur = {
          enabled = "true";
	  size = "3";
	  passes = "1";
	};
      };
      animations = {
        enabled = "true";
	first_launch_animation = "false";
        
	bezier = "myBrezier, 0.05, 0.9, 0.1, 1.05";
	animation = [
	  "windows, 1, 7, myBrezier"
          "windowsOut, 1, 7, default, popin 80%"
	  "border, 1, 10, default"
	  "borderangle, 1, 8, default"
	  "fade, 1, 7, default"
	  "workspaces, 1, 6, default"
        ];
      };
      dwindle = {
        pseudotile = "yes";
	preserve_split = "yes";
      };
      master = {
        new_is_master = "true";
      };
      windowrulev2 = "nomaximizerequest, class:.*";
      exec-once = [
        "waybar"
	"dunst"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "wl-clip-persist --clipboard both"
      ]; 
    };
  };
}
