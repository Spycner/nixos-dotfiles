{
  pkgs,
  lib,
  config,
  ...
}: {
  # light/dark specialisations
  specialisation = let
    colorschemePath = "/org/gnome/desktop/interface/color-scheme";
    dconf = "${pkgs.dconf}/bin/dconf";

    dconfDark = lib.hm.dag.entryAfter ["dconfSettings"] ''
      ${dconf} write ${colorschemePath} "'prefer-dark'"
    '';
    dconfLight = lib.hm.dag.entryAfter ["dconfSettings"] ''
      ${dconf} write ${colorschemePath} "'prefer-light'"
    '';
  in {
    light.configuration = {
      theme.name = "light";
      home.activation = {inherit dconfLight;};
    };
    dark.configuration = {
      theme.name = "dark";
      home.activation = {inherit dconfDark;};
    };
  };

  theme = {
    # specific to unsplash
    wallpaper = let
      params = "?q=85&fm=jpg&crop=fit&cs=srgb&w=2560";
      url = "https://images.unsplash.com/photo-1608507974219-2df72d775da0${params}.jpg";
      sha256 = "00hj6svcfm969h0fmf5hfmgr8sa9vmh789dsl0nzdfqpc1mqy7h2";
      ext = lib.last (lib.splitString "." url);
    in
      builtins.fetchurl {
        name = "wallpaper-${sha256}.${ext}";
        inherit url sha256;
      };

    colorscheme = {
      colors = {
        base00 = "#24273a"; # base
        base01 = "#1e2030"; # mantle
        base02 = "#363a4f"; # surface0
        base03 = "#494d64"; # surface1
        base04 = "#5b6078"; # surface2
        base05 = "#cad3f5"; # text
        base06 = "#f4dbd6"; # rosewater
        base07 = "#b7bdf8"; # lavender
        base08 = "#ed8796"; # red
        base09 = "#f5a97f"; # peach
        base0A = "#eed49f"; # yellow
        base0B = "#a6da95"; # green
        base0C = "#8bd5ca"; # teal
        base0D = "#8aadf4"; # blue
        base0E = "#c6a0f6"; # mauve
        base0F = "#f0c6c6"; # flamingo
      };
    }; 
  };

  programs.matugen = {
    enable = false;
    wallpaper = config.theme.wallpaper;
  };
}
