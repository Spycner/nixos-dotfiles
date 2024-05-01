{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "none";
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
        startup_mode = "Maximized";
      };

      scrolling.history = 10000;

      font = {
        normal.family = "JetBrains Mono";
        bold.family = "JetBrains Mono";
        italic.family = "JetBrains Mono";
        size = 10;
      };

      colors.draw_bold_text_with_bright_colors = true;
      window.opacity = 0.9;

      mouse.hide_when_typing = true;

      import = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-mocha.toml";
          hash = "sha256-/N3rwIZ0SJBiE7TiBs4pEjhzM1f2hr26WXM3ifUzzOY=";
        })
      ];
    };
  };
}
