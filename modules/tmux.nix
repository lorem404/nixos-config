{ pkgs, ... }: {
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
}
