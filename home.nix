{ config, pkgs, ... }:

{
  home.username = "lorem";
  home.homeDirectory = "/home/lorem";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.tmux = {
    enable = true;

    # Basic settings
    terminal = "tmux-256color";
    mouse = true;

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour "mocha"
          set -g @catppuccin_window_status_style "rounded"
        '';
      }
      cpu
      battery
    ];

    extraConfig = ''
      # Status bar configuration
      set -g status-position top
      unbind C-b
      set -g prefix C-s
      bind s send-prefix
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      run-shell ${pkgs.tmuxPlugins.catppuccin.rtp}
    '';
  };

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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [ ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
