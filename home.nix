{ config, pkgs, ... }:

{

  home.username = "lorem";
  home.homeDirectory = "/home/lorem";
  home.stateVersion = "25.05"; # Please read the comment before changing.

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Monitor configuration
      monitor = "eDP-1,preferred,auto,1";

      # Exec-once
      # exec-once = [ ];

      # Input configuration
      input = {
        kb_layout = "us";
        # kb_variant = "";
        # kb_model = "";
        # kb_options = "";
        # kb_rules = "";
        # follow_mouse = 1;
        # sensitivity = 0;
      };

      # General
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff) rgba(ffffffff) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # decoration = {
      #   rounding = 0;
      # blur = { enabled = false; };
      # drop_shadow = false;
      # };

      # Animations
      animations = { enabled = false; };

      # Dwindle
      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      # Master
      master = { new_status = "master"; };

      # Gestures
      gestures = { workspace_swipe = "off"; };

      # Device
      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      # Window rules
      # windowrule = [
      #   "float, ^(kitty)$"
      #   "float,^(pavucontrol)$"
      #   "float,title:^(Open File)(.*)$"
      #   "float,title:^(Branch dialog)(.*)$"
      #   "float,title:^(Confirm to replace files)(.*)$"
      #   "float,title:^(File Operation Progress)(.*)$"
      #   "float,title:^(Opening)(.*)$"
      #   "float,title:^(Progress)(.*)$"
      #   "float,title:^(Replace)(.*)$"
      #   "float,title:^(mpv)$"
      # ];
      # # Window rule v2
      # windowrulev2 = "suppressevent maximize, class:.*";

      # Key bindings (exactly as in default config)
      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, dolphin"
        "$mainMod, V, togglefloating"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        ''$mainMod, S, exec, grim -g "$(slurp)" - | wl-copy''
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };

    # Extra config (environment variables and misc)
    extraConfig = ''
      # Environment variables
      env = XCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      # Some default env vars.
      env = XCURSOR_SIZE,24
      env = QT_QPA_PLATFORM,wayland;xcb
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    '';
  };

  # Required packages for the default config to work
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

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format =
        "$directory$git_branch$git_status$cmd_duration$line_break$character";
    };
  };

  programs.git = {
    enable = true;
    userName = "lorem";
    userEmail = "lorem8023@gmail.com";

    aliases = { lg = "log --color --graph "; };

    extraConfig = { core.editor = "nvim"; };
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
