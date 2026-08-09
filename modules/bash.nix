{
  config,
  pkgs,
  ...
}: {
  programs.bash = {
    enable = true;
    blesh.enable = true; # Fish‑like line editor

    # Standard enhancements
    completion.enable = true;
    vteIntegration = true;

    # Shell aliases (like Fish defaults)
    shellAliases = {
      grep = "grep --color=auto";
      h = "history";
      ls = "lsd -thral";
      v = "nvim";
      c = "clear";
      fbat = "fzf -m --preview='bat --color=always {}'";
      fv = "nvim $(fzf -m --preview='bat --color=always {}')";
      t = "tmux";
    };

    # ----- Fish‑like interactive settings -----
    # interactiveShellInit = ''
    #   # ---- Thin cursor (like Fish) ----
    #   bleopt cursor_type=line
    #
    #   # ---- Autosuggestion colour (grey, like Fish) ----
    #   ble-face -s auto_suggestion 'fg=240'
    #
    #   # ---- Syntax colours (closer to Fish) ----
    #   ble-face -s syntax_command 'fg=blue'
    #   ble-face -s syntax_string 'fg=magenta'
    #   ble-face -s syntax_function 'fg=green'
    #   ble-face -s syntax_variable 'fg=yellow'
    #
    #   # ---- Key bindings (Fish‑style history search) ----
    #   # Fixed ble.sh key bindings for substring history search with point at end
    #   ble-bind -f C-x p 'history-substring-search-backward hide-status:point=end:immediate-accept'
    #   ble-bind -f C-x n 'history-substring-search-forward hide-status:point=end:immediate-accept'
    #
    #   # ---- Prompt (Starship) ----
    #   eval "$(starship init bash)"
    # '';
    interactiveShellInit = ''
      echo -ne "\e[6 q"
      # ---- Autosuggestion style (grey, like Fish) ----
      ble-face -s auto_complete 'fg=240'

      # ---- Syntax highlighting faces ----
      ble-face -s syntax_default   'fg=white'
      ble-face -s syntax_command   'fg=blue'
      ble-face -s syntax_delimiter 'fg=magenta'
      ble-face -s syntax_param_expansion 'fg=yellow'
      ble-face -s syntax_history_expansion 'fg=green'

      # ---- Prompt (Starship) ----
      eval "$(starship init bash)"
    '';
  };
}
