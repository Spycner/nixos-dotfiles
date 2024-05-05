{ outputs, config, lib, pkgs, ... }:

let

  home.packages = with pkgs; [
    jq
  ];

  # Dependencies
  bat = "${pkgs.bat}/bin/bat";
  cut = "${pkgs.coreutils}/bin/cut";
  find = "${pkgs.findutils}/bin/find";
  grep = "${pkgs.gnugrep}/bin/grep";
  pgrep = "${pkgs.procps}/bin/pgrep";
  tail = "${pkgs.coreutils}/bin/tail";
  wc = "${pkgs.coreutils}/bin/wc";
  xargs = "${pkgs.findutils}/bin/xargs";
  timeout = "${pkgs.coreutils}/bin/timeout";
  ping = "${pkgs.iputils}/bin/ping";

  jq = "${pkgs.jq}/bin/jq";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  wofi = "${pkgs.wofi}/bin/wofi";

  # Function to simplify making waybar outputs
  jsonOutput = name: { pre ? "", text ? "", tooltip ? "", alt ? "", class ? "", percentage ? "" }: "${pkgs.writeShellScriptBin "waybar-${name}" ''
    set -euo pipefail
    ${pre}
    ${jq} -cn \
      --arg text "${text}" \
      --arg tooltip "${tooltip}" \
      --arg alt "${alt}" \
      --arg class "${class}" \
      --arg percentage "${percentage}" \
      '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
  ''}/bin/waybar-${name}";
in
{
  # Let it try to start a few more times
  systemd.user.services.waybar = {
    Unit.StartLimitBurst = 30;
  };
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        mode = "dock";
        layer = "top";
        height = 40;
        margin = "4";
        position = "top";
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
          "custom/currentplayer"
          "custom/player"
        ];

        modules-center = [
          "cpu"
          "custom/gpu"
          "memory"
          "clock"
          "pulseaudio"
          "battery"
        ];

        modules-right = [
          "network"
          "tray"
          "custom/hostname"
        ];

        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''
              player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
              count="$(${playerctl} -l 2>/dev/null | ${wc} -l)"
              if ((count > 1)); then
                more=" +$((count - 1))"
              else
                more=""
              fi
            '';
            alt = "$player";
            tooltip = "$player ($count available)";
            text = "$more1";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "spotify" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "chromium" = " ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };

        "custom/player" = {
          exec-if = "${playerctl} status 2>/dev/null";
          exec = ''${playerctl} metadata --format '{"text": "{{title}} - {{artist}}", "alt": "{{status}}", "tooltip": "{{title}} - {{artist}} ({{album}})"}' 2>/dev/null '';
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = " 󰐊 ";
            "Paused" = " 󰏤 ";
            "Stopped" = " 󰓛 ";
          };
          on-click = "${playerctl} play-pause";
        };

        cpu = {
          format = " {usage}%";
        };

        "custom/gpu" = {
          interval = 5;
          exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{print $1}'";
          format = "󰒋 {}%";
        };

        memory = {
          format = " {}%";
          interval = 5;
        };

        clock = {
          interval = 1;
          format = "{:%d/%m %H:%M:%S}";
          format-alt = "{:%Y-%m-%d %H:%M:%S %z}";
          on-click-left = "mode";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        pulseaudio = {
          format = "{icon}{volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [ "" "" "" ];
          };
          on-click = pavucontrol;
        };

        battery = {
          bat = "BAT0";
          interval = 10;
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };

        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈁 Connected";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
          on-click = "${systemctl} --user restart waybar";
        };
      };
    };

    style = ''
      /* Catppuccin Mocha Color Palette */
      /* @define-color rosewater: #f8bd96;
      @define-color flamingo: #f2cdcd;
      @define-color pink: #f5c2e7;
      @define-color mauve: #cba6f7;
      @define-color red: #f38ba8;
      @define-color maroon: #eba0ac;
      @define-color peach: #fab387;
      @define-color yellow: #f9e2af;
      @define-color green: #a6e3a1;
      @define-color teal: #94e2d5;
      @define-color blue: #89dceb;
      @define-color sky: #74c7ec;
      @define-color sapphire: #89b4fa;
      @define-color lavender: #b4befe;
      @define-color text: #cdd6f4;
      @define-color subtext1: #bac2de;
      @define-color subtext0: #a6adc8;
      @define-color overlay: #938aa2;
      @define-color surface: #6e6c7e;
      @define-color base: #575268;
      @define-color mantle: #434257;
      @define-color crust: #313244; */
      
      /* General Styling */
      * {
      font-family: "Inter", "JetBrains Mono", "Noto Color Emoji", monospace;
      font-size: 12pt;
      font-weight: bold;
      padding: 0;
      margin: 0 0.4em;
      }
      
      /* Waybar Window */
      window#waybar {
      padding: 0;
      opacity: 0.75;
      border-radius: 0.5em;
      background-color: #313244;
      color: #cdd6f4;
      }
      
      /* Module Containers */
      .modules-left,
      .modules-right {
      margin: 0 0.5em;
      }
      
      /* Workspaces */
      #workspaces button {
      background-color: #313244;
      color: #cdd6f4;
      padding: 0.15em 0.4em;
      }
      
      #workspaces button.hidden {
      background-color: #313244;
      color: #cdd6f4;
      }
      
      #workspaces button.focused,
      #workspaces button.active {
      background-color: #89b4fa;
      color: #313244;
      }
      
      #workspaces button:hover {
      background-color: #575268;
      }
      
      /* Clock, Custom Menu, Hostname */
      #clock,
      #custom-menu,
      #custom-hostname {
      background-color: #434257;
      padding: 0 1em;
      border-radius: 0.5em;
      }
      
      #custom-menu {
      padding-right: 1.5em;
      margin-right: 0;
      }
      
      #custom-hostname {
      margin-left: 0;
      }
      
      /* Current Player */
      #custom-currentplayer {
      padding-right: 0;
      }
      
      /* Tray */
      #tray {
      color: #cdd6f4;
      }
      
      /* GPU, CPU, Memory */
      #custom-gpu,
      #cpu,
      #memory {
      margin: 0 0.5em 0 0.05em;
      }

      #cpu,
      #custom-gpu, 
      #memory,
      #clock {
        color: #cba6f7;
      }
    '';
  };
}
