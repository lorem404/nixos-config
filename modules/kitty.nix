{ pkgs, ... }: {
  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font";
      size = 12.0;
    };

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      cursor_trail = 100;
      hide_window_decorations = "yes";
      background_opacity = 100;
      background = "#1e1e2e";
      foreground = "#cdd6f4";
    };

    shellIntegration.enableFishIntegration = true;
  };
}
