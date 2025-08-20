{ config, pkgs, ... }:

{

  home.username = "lorem";
  home.homeDirectory = "/home/lorem";
  home.stateVersion = "25.05"; # Please read the comment before changing.

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    # GNOME-style CSS
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Cantarell", "Font Awesome 6 Free";
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
      }

      window#waybar {
        background: rgba(46, 52, 64, 0.95);
        color: #eceff4;
        border-bottom: 1px solid rgba(76, 86, 106, 0.5);
        padding: 0;
      }

      /* Workspaces like GNOME */
      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 0 8px;
        color: #d8dee9;
        background: transparent;
        margin: 2px 1px;
        border-radius: 6px;
      }

      #workspaces button.active {
        background: rgba(94, 129, 172, 0.3);
        color: #88c0d0;
      }

      #workspaces button:hover {
        background: rgba(94, 129, 172, 0.2);
      }

      /* Modules */
      #clock, #pulseaudio, #network, #cpu, #memory, #battery, #tray {
        padding: 0 12px;
        margin: 2px 0;
        color: #eceff4;
      }

      #clock {
        font-weight: 600;
      }

      #pulseaudio.muted {
        color: #bf616a;
      }

      #battery.charging {
        color: #a3be8c;
      }

      #battery.warning:not(.charging) {
        color: #ebcb8b;
      }

      #battery.critical:not(.charging) {
        color: #bf616a;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        50% { opacity: 0.3; }
      }

      #tray {
        padding: 0 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;

        # GNOME-style layout (centered window title, right-side indicators)
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right =
          [ "pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray" ];

        # Workspaces like GNOME activities
        "workspaces" = {
          format = "{name}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            default = "";
          };
          disable-scroll = true;
          all-outputs = true;
        };

        # Window title (like GNOME)
        "sway/window" = {
          format = "{}";
          max-length = 60;
          tooltip = false;
        };

        # Clock (GNOME style)
        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
        };

        # Audio (GNOME style)
        "pulseaudio" = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "󰖁";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        # Network (GNOME style)
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) 󰖩";
          format-ethernet = " {ifname}";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-alt = "{ipaddr}/{cidr}";
          on-click = "nm-connection-editor";
        };

        # CPU
        "cpu" = {
          format = "󰻠 {usage}%";
          interval = 2;
        };

        # Memory
        "memory" = {
          format = "󰍛 {}%";
          interval = 2;
        };

        # Battery (GNOME style)
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰚥";
          format-alt = "{time} {icon}";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        # System tray (GNOME style)
        "tray" = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Monitor configuration
      monitor = "eDP-1,preferred,auto,1";

      # Exec-once
      # exec-once = [ ];
      exec-once = "waybar &";

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
      "$mod" = "SUPER";

      bind = [

        # Power actions
        "$mod SHIFT ,P, exec, systemctl poweroff"
        "$mod SHIFT ,R, exec, systemctl reboot"
        "$mod SHIFT ,S, exec, systemctl suspend"

        # Battery saver mode
        "$mod SHIFT ,B, exec, powerprofilesctl set power-saver"
        "$mod SHIFT, N, exec, powerprofilesctl set balanced"
        "$mod SHIFT ,M, exec, powerprofilesctl set performance"
        "$mod, Q, exec, kitty"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        ''$mod, S, exec, grim -g "$(slurp)" - | wl-copy''
      ];

      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
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
