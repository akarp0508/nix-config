{ lib, ... }:
let
  # Black + bright green color scheme, shared with noctalia-greeter.
  colors = {
    primary = "#39FF14";
    onPrimary = "#000000";
    secondary = "#22C55E";
    onSecondary = "#000000";
    tertiary = "#86EFAC";
    onTertiary = "#000000";
    error = "#FF4444";
    onError = "#000000";
    surface = "#000000";
    onSurface = "#E8FFE8";
    surfaceVariant = "#101810";
    onSurfaceVariant = "#7FBF8F";
    outline = "#1F4D2E";
    shadow = "#000000";
    hover = "#4AFF2E";
    onHover = "#000000";
  };
in
{
  flake.lib.colors = colors;

  perSystem = { pkgs, ... }:
  let
    paletteName = "NeonGreen";

    # noctalia 5.4.0 only parses the m-prefixed palette format (the docs'
    # `version = 2` snake_case format is newer and silently renders text
    # transparent here), and it rejects a palette without a `terminal` block.
    palette = {
      dark = lib.mapAttrs' (name: lib.nameValuePair "m${lib.toUpper (lib.substring 0 1 name)}${lib.substring 1 (-1) name}") colors // {
        terminal = {
          background = "#000000";
          foreground = "#E8FFE8";
          cursor = "#39FF14";
          cursorText = "#000000";
          selectionBg = "#1F4D2E";
          selectionFg = "#E8FFE8";
          normal = {
            black = "#101810"; red = "#FF4444"; green = "#22C55E"; yellow = "#D4E157";
            blue = "#26A69A"; magenta = "#9CCC65"; cyan = "#4DD0B1"; white = "#7FBF8F";
          };
          bright = {
            black = "#1F4D2E"; red = "#FF6B6B"; green = "#39FF14"; yellow = "#EEFF41";
            blue = "#64FFDA"; magenta = "#B2FF59"; cyan = "#86EFAC"; white = "#E8FFE8";
          };
        };
      };
    };

    # Noctalia v5 config (TOML). It merges every *.toml in the config dir, then
    # ~/.local/state/noctalia/settings.toml on top, which is where the settings
    # UI writes. So this can live read-only in the store while the GUI still
    # works; a GUI change shadows the value here until removed from that file.
    settings = {
      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = paletteName;
      };

      bar.default = {
        position = "top";
        thickness = 34;
        margin_ends = 0;
        margin_edge = 0;
        background_opacity = 0.93;
        # Square top corners, flush with the screen edge.
        radius_top_left = 0;
        radius_top_right = 0;
        capsule = true;
        widget_spacing = 4;
        start = [ "launcher" "clock" "active_window" "media" ];
        center = [ "workspace_apps" ];
        end = [ "tray" "notifications" "cpu" "temp" "ram" "battery" "volume" "control-center" ];

        # Slimmer bars on the side monitors. Matched by model (a substring of
        # the output description) so it survives port swaps.
        monitor = lib.genAttrs [ "C27JG5x" "PL2488H" ] (model: {
          match = model;
          start = [ "launcher" "clock" ];
          center = [ "workspace_apps" ];
          end = [ "tray" "notifications" "volume" "control-center" ];
        });
      };

      widget = {
        clock = {
          format = "{:%H:%M %a, %b %d}";
          vertical_format = "{:%H\n%M}";
          tooltip_format = "{:%H:%M %a, %b %d}";
        };
        # One group per workspace showing the icons of the apps on it (the v4
        # workspace widget's showApplications); 5.4.0's own workspaces widget
        # can only show labels or the focused window's icon.
        workspace_apps = {
          type = "taskbar";
          group_by_workspace = true;
          workspace_group_content = "icons";
          show_workspace_label = false;
        };
        active_window.max_length = 145.0;
        media.max_length = 145.0;
      };

      wallpaper = {
        enabled = true;
        directory = "/home/akarp0508/Pictures/Wallpapers";
        fill_mode = "crop";
        fill_color = "#000000";
        transition = [ "fade" "disc" "stripes" "wipe" "pixel" "honeycomb" ];
        transition_duration = 1500;
        edge_smoothness = 0.05;
      };

      location.address = "Warsaw";
      weather.unit = "metric";

      # noctalia's built-in polkit authentication agent (password prompts for
      # privileged actions); there's no other agent running in the session.
      shell.polkit_agent = true;

      idle = {
        pre_action_fade_seconds = 5.0;
        behavior = {
          screen-off = { action = "screen_off"; enabled = true; timeout = 300.0; };
          lock = { action = "lock"; enabled = true; timeout = 330.0; };
          lock-and-suspend = { action = "lock_and_suspend"; enabled = true; timeout = 1800.0; };
        };
      };

      nightlight = {
        enabled = true;
        temperature_night = 4515;
      };

      osd.position = "top_right";
      # No "now playing" popup on every track change.
      osd.kinds.media = false;

      dock = {
        enabled = true;
        position = "bottom";
        auto_hide = true;
        # Overlay windows when it slides in instead of reserving a strip at
        # the bottom of every screen.
        reserve_space = false;
      };
    };

    configHome = pkgs.linkFarm "noctalia-config" {
      "noctalia/config.toml" = (pkgs.formats.toml { }).generate "config.toml" settings;
      "noctalia/palettes/${paletteName}.json" = pkgs.writeText "${paletteName}.json" (builtins.toJSON palette);
    };
  in
  {
    packages.myNoctalia = pkgs.symlinkJoin {
      name = "noctalia-${pkgs.noctalia.version}";
      paths = [ pkgs.noctalia ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      # LD_LIBRARY_PATH is unset because the system-wide one (nix-ld.nix, for
      # JavaFX's dlopen'd libs) drags in an older libstdc++ that shadows the
      # newer one noctalia's own binary needs via RUNPATH, crashing it.
      postBuild = ''
        wrapProgram $out/bin/noctalia \
          --unset LD_LIBRARY_PATH \
          --set NOCTALIA_CONFIG_HOME ${configHome}
      '';
      meta = pkgs.noctalia.meta // { mainProgram = "noctalia"; };
    };
  };
}
