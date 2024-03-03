{pkgs, inputs, ...}: {
  programs.firefox = {
    enable = true;
    profiles.pkraus = {
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              {name = "type"; value = "packages";}
              {name = "query"; value ="{searchTerms}";}
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
      };
      search.force = true;

      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        firefox-color
        youtube-shorts-block
        ublock-origin
        darkreader
        sourcegraph
      ];
    };
  };
}
