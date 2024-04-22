{ outputs, config, lib, pkgs, ... }:

let
  # Dependencies
  bat = "${pkgs.coreutils}/bin/bat";
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
  #! Todo: change wofi to anyrun
  # wofi = "${pkgs.wofi}/bin/wofi";

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

  hasHyprland = config.wayland.windowManager.hyprland.enable;
  hyprland = config.wayland.windowManager.hyprland.package;
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
        margin = "6";
        position = "top";
        modules-left = [
          "custom/menu"
        ] ++ (lib.optionals hasHyprland [
          "hyprland/workspaces"
          "hyprland/submap"
        ]) ++ [
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
          # "custom/gammastep" TODO: currently broken for some reason
          "network"
          "tray"
          "custom/hostname"
        ];

        clock = {
          interval = 1;
          format = "{:%d/%m %H:%M:%S}";
          format-alt = "{:%Y-%m-%d %H:%M:%S %z}";
          on-click-left = "mode";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };

        cpu = {
          format = "  {usage}%";
        };
        "custom/gpu" = {
          interval = 5;
          exec = "${bat} /sys/class/drm/card0/device/gpu_busy_percent";
          format = "󰒋  {}%";
        };
        memory = {
          format = "  {}%";
          interval = 5;
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [ "" "" "" ];
          };
          on-click = pavucontrol;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
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
        "custom/menu" = {
          return-type = "json";
          exec = jsonOutput "menu" {
            text = "";
            tooltip = ''$(${bat} /etc/os-release | ${grep} PRETTY_NAME | ${cut} -d '"' -f2)'';
          };
          # Todo: change wofi to anyrun
          # on-click-left = "${wofi} -S drun -x 10 -y 10 -W 25% -H 60%";
          on-click-right = lib.concatStringsSep ";" (
            (lib.optional hasHyprland "${hyprland}/bin/hyprctl dispatch togglespecialworkspace")
          );

        };
        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
          on-click = "${systemctl} --user restart waybar";
        };
        "custom/gammastep" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gammastep" {
            pre = ''
              if unit_status="$(${systemctl} --user is-active gammastep)"; then
                status="$unit_status ($(${journalctl} --user -u gammastep.service -g 'Period: ' | ${tail} -1 | ${cut} -d ':' -f6 | ${xargs}))"
              else
                status="$unit_status"
              fi
            '';
            alt = "\${status:-inactive}";
            tooltip = "Gammastep is $status";
          };
          format = "{icon}";
          format-icons = {
            "activating" = "󰁪 ";
            "deactivating" = "󰁪 ";
            "inactive" = "? ";
            "active (Night)" = " ";
            "active (Nighttime)" = " ";
            "active (Transition (Night)" = " ";
            "active (Transition (Nighttime)" = " ";
            "active (Day)" = " ";
            "active (Daytime)" = " ";
            "active (Transition (Day)" = " ";
            "active (Transition (Daytime)" = " ";
          };
          on-click = "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
        };
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
            text = "$more";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "Celluloid" = "󰎁 ";
            "spotify" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "qutebrowser" = "󰖟 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
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
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
        };
      };

    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left
    style = /* css */ ''
      * {
        font-family: "Inter", "JetBrains Mono", "Noto Color Emoji";
        font-size: 12pt;
        padding: 0;
        margin: 0 0.4em;
      }

      window#waybar {
        padding: 0;
        opacity: 0.75;
        border-radius: 0.5em;
        background-color: #24273a;
        color: #cad3f5;
      }
      .modules-left,
      .modules-right {
        margin: 0 0.5em;
      }

      #workspaces button {
        background-color: #24273a;
        color: #cad3f5;
        padding-left: 0.4em;
        padding-right: 0.4em;
        margin-top: 0.15em;
        margin-bottom: 0.15em;
      }
      #workspaces button.hidden {
        background-color: #24273a;
        color: #5b6078;
      }
      #workspaces button.focused,
      #workspaces button.active {
        background-color: #eed49f;
        color: #24273a;
      }
      #workspaces button:hover {
        background-color: #494d64;
        color: #b7bdf8;
      }

      #clock {
        background-color: #1e2030;
        padding-right: 1em;
        padding-left: 1em;
        border-radius: 0.5em;
      }

      #custom-menu {
        background-color: #1e2030;
        padding-right: 1.5em;
        padding-left: 1em;
        margin-right: 0;
        border-radius: 0.5em;
      }
      #custom-hostname {
        background-color: #1e2030;
        padding-right: 1em;
        padding-left: 1em;
        margin-left: 0;
        border-radius: 0.5em;
      }
      #custom-currentplayer {
        padding-right: 0;
      }
      #tray {
        color: #cad3f5;
      }
      #custom-gpu, #cpu, #memory {
        margin-left: 0.05em;
        margin-right: 0.55em;
      }
    '';

  };
}