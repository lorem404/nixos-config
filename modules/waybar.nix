{pkgs, ...}: {
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
      #hyprland-workspaces {
        padding: 0 4px;
      }

      #hyprland-workspaces button {
        padding: 0 8px;
        color: #d8dee9;
        background: transparent;
        margin: 2px 1px;
        border-radius: 6px;
      }

      #hyprland-workspaces button.active {
        background: rgba(94, 129, 172, 0.3);
        color: #88c0d0;
      }

      #hyprland-workspaces button:hover {
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
        modules-left = ["hyprland/workspaces"];
        modules-center = ["window"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "clock" "tray"];

        # Workspaces like GNOME activities
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1"; # Desktop
            "2" = "2"; # Browser (Chrome/Firefox)
            "3" = "3"; # Code (VS Code/Neovim)
            "4" = "4"; # Chat (Discord/Slack)
            "5" = "5"; # Music (Spotify)
            "6" = "6"; # Video (MPV)
            "7" = "7"; # Email
            "8" = "8"; # Settings
            "9" = "9"; # Games
            "10" = "10"; # Terminal
            urgent = ""; # Urgent workspace (alert)
            default = ""; # Default icon
          };

          # Behavior settings
          active-only = false; # Show only active workspaces
          all-outputs = true; # Show workspaces from all monitors
          disable-scroll = false; # Enable scroll to change workspaces
          persistent_workspaces = {
            # Persistent workspaces per monitor
            "*" = 5; # 5 workspaces on all monitors
          };

          # Click actions
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        # Window title (like GNOME)
        "window" = {
          format = "{}";
          max-length = 60;
          tooltip = false;
        };

        # Clock (GNOME style)
        "clock" = {
          format = "{:%H-:%M}";
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
            default = ["" "" ""];
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
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };

        # System tray (GNOME style)
        "tray" = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };
  };
}
