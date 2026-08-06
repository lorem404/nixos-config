{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    systemd.enable = true;

    # Hyprland 0.55+ dropped hyprlang in favor of a Lua config.
    # `settings = {...}` (hyprlang serializer) is broken for this backend right now,
    # so we write the whole config as raw Lua below instead.
    configType = "lua";

    # Inlined as .text (not .source) so there's no external file path or
    # git-tracking requirement to worry about.
    extraConfig = ''
      -- Ported from hyprlang config
      -- Verify dispatchers/env calls against: https://wiki.hypr.land/Configuring/Basics/Dispatchers/

      ------------------------------------------------------
      -- VARS
      ------------------------------------------------------
      local mainMod = "SUPER"

      ------------------------------------------------------
      -- MONITOR
      ------------------------------------------------------
      hl.monitor({
        output   = "eDP-1",
        mode     = "preferred",
        position = "auto",
        scale    = 1,
      })

      ------------------------------------------------------
      -- GENERAL / INPUT / DWINDLE / MASTER / ANIMATIONS
      ------------------------------------------------------
      hl.config({
        general = {
          gaps_in     = 0,
          gaps_out    = 0,
          border_size = 2,
          ["col.active_border"] = "rgba(ffffffff)",
          ["col.inactive_border"] = "rgba(595959aa)",
          layout = "dwindle",
        },

        input = {
          kb_layout    = "us",
          follow_mouse = 1,
          sensitivity  = 0,
          touchpad = {
            natural_scroll = false,
          },
        },

        animations = {
          enabled = false,
        },

        dwindle = {
          preserve_split = true,
        },

        master = {
          new_status = "master",
        },
      })

      ------------------------------------------------------
      -- ENVIRONMENT VARIABLES
      -- NOTE: hl.env(...) is my best-guess mapping (from a third-party
      -- hyprlang->lua converter), not confirmed against the official wiki.
      -- If `hyprctl reload` errors on these lines, check the Variables page:
      -- https://wiki.hypr.land/Configuring/Basics/Variables/
      ------------------------------------------------------
      hl.env("XCURSOR_SIZE", "24")
      hl.env("QT_QPA_PLATFORM", "wayland;xcb")
      hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

      ------------------------------------------------------
      -- KEYBINDS
      ------------------------------------------------------

      -- Volume / brightness / power
      hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("pamixer -i 10"))
      hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("pamixer -d 10"))
      hl.bind(mainMod .. " + F5", hl.dsp.exec_cmd("brightnessctl set +10%"))
      hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("brightnessctl set 10%-"))

      hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("systemctl poweroff"))
      hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("systemctl reboot"))
      hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("systemctl suspend"))
      hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("powerprofilesctl set power-saver"))
      hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("powerprofilesctl set balanced"))
      hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("powerprofilesctl set performance"))

      -- Apps
      hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
      hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("kitty"))
      hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
      hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))
      hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

      -- Window management
      hl.bind(mainMod .. " + C", hl.dsp.window.close())
      hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

      -- Exit Hyprland
      -- (if you use uwsm, swap for hl.dsp.exec_cmd("uwsm stop") instead —
      -- see https://wiki.hypr.land/Configuring/Basics/Dispatchers/)
      hl.bind(mainMod .. " + M", hl.dsp.exit())

      -- Focus movement
      -- NOTE: exact dispatcher shape for directional focus not fully confirmed —
      -- verify with `hyprctl dispatch 'hl.dsp.???'` if this errors on reload.
      hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
      hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
      hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

      -- Workspaces 1-10 (SUPER+0 = workspace 10), SHIFT+num moves window
      for i = 1, 10 do
        local key = (i == 10) and "0" or tostring(i)
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      -- Scroll wheel workspace switching
      hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_raw("workspace e+1"))
      hl.bind(mainMod .. " + mouse_up",   hl.dsp.exec_raw("workspace e-1"))

      -- Mouse-driven move/resize
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
