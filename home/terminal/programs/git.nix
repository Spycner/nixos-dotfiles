{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  # enable scrolling in git diff
  home.sessionVariables.DELTA_PAGER = "less -R";

  programs.git = {
    enable = true;

    delta = {
      enable = true;
      options.${config.theme.name} = true;
    };

    extraConfig = {
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
    };

    ignores = ["*~" "*.swp" "*result*" ".direnv" "node_modules"];

    extraConfig.gpg.format = "ssh";

    userEmail = "pascal98kraus@gmail.com";
    userName = "Spycner";
  };
}
