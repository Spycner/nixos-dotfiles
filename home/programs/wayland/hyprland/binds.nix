let
  screenshotarea = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave area; hyprctl keyword animation 'fadeOut,1,4,default'";

  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "$mod, ${ws}, workspace, ${toString (x + 1)}"
        "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  wayland.windowManager.hyprland.settings = {
    # mouse movements
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    # binds
    bind = let
      monocle = "dwindle:no_gaps_when_only";
    in
      [
        # compositor commands
        "$mod SHIFT, E, exec, pkill Hyprland"
        "$mod, C, killactive,"
        "$mod, F, fullscreen,"
        "$mod, G, togglegroup,"
        "$mod SHIFT, N, changegroupactive, f"
        "$mod SHIFT, P, changegroupactive, b"
        "$mod, R, togglesplit,"
        "$mod, T, togglefloating,"
        "$mod, P, pseudo,"
        "$mod ALT, ,resizeactive,"

        # toggle "monocle" (no_gaps_when_only)
        "$mod, M, exec, hyprctl keyword ${monocle} $(($(hyprctl getoption ${monocle} -j | jaq -r '.int') ^ 1))"

        # utility
        # terminal
        "$mod, Q, exec, run-as-service alacritty"
        # logout menu
        "$mod, Escape, exec, wlogout -p layer-shell"
        # lock screen
        "$mod, L, exec, loginctl lock-session"
        # select area to perform OCR on
        "$mod, O, exec, run-as-service wl-ocr"

        # move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # screenshot
        # stop animations while screenshotting; makes black border go away
        ", Print, exec, ${screenshotarea}"
        "$mod SHIFT, R, exec, ${screenshotarea}"

        "CTRL, Print, exec, grimblast --notify --cursor copysave output"
        "$mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output"

        "ALT, Print, exec, grimblast --notify --cursor copysave screen"
        "$mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen"

        # cycle workspaces
        "$mod, ., workspace, m-1"
        "$mod, -, workspace, m+1"

        # cycle monitors
        "$mod SHIFT, ., focusmonitor, l"
        "$mod SHIFT, -, focusmonitor, r"

        # send focused workspace to left/right monitors
        "$mod SHIFT ALT, ., movecurrentworkspacetomonitor, l"
        "$mod SHIFT ALT, -, movecurrentworkspacetomonitor, r"
      ]
      ++ workspaces;

    bindr = [
      # launcher
      "$mod, SUPER_L, exec, pkill .anyrun-wrapped || run-as-service anyrun"
    ];

    bindl = [
      # media controls
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"

      # volume
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];

    bindle = [
      # volume
      ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

      # backlight
      ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
      ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
    ];
  };
}
