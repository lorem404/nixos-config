{ pkgs, ... }: {
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
      "$mod" = "SUPER";

      bind = [
        # 🎛️ Advanced Controls (with notifications)
        "$mod, F3, exec, pamixer -i 10"
        "$mod, F2, exec, pamixer -d 10"
        "$mod, F5, exec, brightnessctl set +10%"
        "$mod, F4, exec, brightnessctl set 10%-"

        # Power actions
        "$mod SHIFT ,P, exec, systemctl poweroff"
        "$mod SHIFT ,R, exec, systemctl reboot"
        "$mod SHIFT ,S, exec, systemctl suspend"

        # Battery saver mode
        "$mod SHIFT ,B, exec, powerprofilesctl set power-saver"
        "$mod SHIFT, N, exec, powerprofilesctl set balanced"
        "$mod SHIFT ,M, exec, powerprofilesctl set performance"
        "$mod ,B, exec, firefox"
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

}
