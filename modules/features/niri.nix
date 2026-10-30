{ self, inputs, ... }: {
  flake.nixosModules.niri = { config, pkgs, lib, ... }:
  let
    packages = self.packages.${pkgs.stdenv.hostPlatform.system};

    toOutput = m:
      if !m.enable then { off = _: { }; }
      else {
        mode = "${toString m.width}x${toString m.height}"
          + lib.optionalString (m.refresh != null) "@${toString m.refresh}";
        scale = m.scale;
        transform = m.transform;
        position = _: { props = { inherit (m) x y; }; };
      }
      // lib.optionalAttrs (m.vrr == "on") { variable-refresh-rate = _: { }; }
      // lib.optionalAttrs (m.vrr == "on-demand") {
        variable-refresh-rate = _: { props.on-demand = true; };
      }
      // lib.optionalAttrs m.primary { focus-at-startup = _: { }; };

    # Raw KDL text, not the `workspaces` settings option: Nix attrsets always
    # enumerate sorted by key, so building this via an attrset would silently
    # re-sort the workspaces alphabetically instead of respecting the order
    # each monitor lists them in.
    workspacesKdl = lib.concatStrings (
      lib.concatLists (
        lib.mapAttrsToList
          (outputName: m: map (name: ''
            workspace "${name}" {
                open-on-output "${outputName}"
            }
          '') m.workspaces)
          config.monitors
      )
    );

    noctalia = lib.getExe packages.myNoctalia;
  in
  {
    imports = [
      self.nixosModules.monitors
    ];

    # Wallpaper image for the desktop. Applied by niri at session startup.
    # Shared default so every niri host gets the same look unless a host overrides it.
    options.wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = ./wallpaper.png;
      description = "Wallpaper image, set on all monitors at login.";
    };

    config.environment.systemPackages = [ pkgs.bibata-cursors ];

    config.programs.niri = {
      enable = true;
      package = packages.myNiri.wrap {
        settings = {
          outputs = lib.mapAttrs (_: toOutput) config.monitors;

          extraConfig = workspacesKdl;

          # Direct jump to a named workspace regardless of which monitor is
          # currently focused: qwe -> L1-3, rtfgvb -> M1-6, zxc -> R1-3.
          binds = lib.foldl' (acc: b: acc // b) { } (
            lib.mapAttrsToList
              (key: ws: {
                "Mod+${key}".focus-workspace = ws;
                "Mod+Shift+${key}".move-column-to-workspace = ws;
              })
              {
                Q = "L1"; W = "L2"; E = "L3";
                R = "M1"; T = "M2"; F = "M3"; G = "M4"; V = "M5"; B = "M6";
                Z = "R1"; X = "R2"; C = "R3";
              }
          );

          # noctalia keeps the wallpaper as runtime state, so set it over IPC once it's up.
          spawn-sh-at-startup = lib.optional (config.wallpaper != null) ''
            for i in $(seq 30); do
              ${noctalia} ipc call wallpaper set ${config.wallpaper} all && break
              sleep 1
            done
          '';

          spawn-at-startup = [
            (lib.getExe pkgs.discord)
            (lib.getExe pkgs.spotify)
          ];

          # open-focused false keeps startup focus on M1 (the primary
          # output's focus-at-startup output, above) instead of jumping to
          # whichever of these opens last.
          window-rules = [
            {
              matches = [ { app-id = "^discord$"; } ];
              open-on-workspace = "L1";
              open-focused = false;
            }
            {
              matches = [ { app-id = "^Spotify$"; } ];
              open-on-workspace = "R1";
              open-focused = false;
            }
          ];
        };
      };
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs; # required, or the wrapper resolves packages against its own pkgs instead of this flake's
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        cursor = {
          xcursor-theme = "Bibata-Modern-Classic";
          xcursor-size = 22;
        };

        # Ask clients to skip drawing their own titlebar. clip-to-geometry +
        # draw-border-with-background keep windows that still draw their own
        # shadow/corners (despite agreeing to drop CSD) from looking broken.
        # geometry-corner-radius rounds every window; clip-to-geometry forces
        # the window content itself to round to match (not just the ring).
        prefer-no-csd = _: { };
        window-rules = [
          {
            clip-to-geometry = true;
            draw-border-with-background = false;
            geometry-corner-radius = 10;
          }
        ];

        input.keyboard.xkb.layout = "pl";

        layout.gaps = 5;
        layout.preset-column-widths = _: {
          content = [
            { proportion = 0.5; }
            { proportion = 1.0; }
          ];
        };
        layout.default-column-width.proportion = 1.0;
        layout.focus-ring.active-color = "#39FF14";
        layout.focus-ring.width = 1;

        # The generated config replaces niri's default one, so every bind has to be listed here.
        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = _: { };

          "Mod+Return".spawn = lib.getExe pkgs.kitty;
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+A".close-window = _: { };
          "Mod+8".toggle-overview = _: { };

          "Mod+Left".focus-column-left = _: { };
          "Mod+Right".focus-column-right = _: { };
          "Mod+Up".focus-window-up = _: { };
          "Mod+Down".focus-window-down = _: { };
          "Mod+J".focus-column-left = _: { };
          "Mod+L".focus-column-right = _: { };
          "Mod+I".focus-window-up = _: { };
          "Mod+K".focus-window-down = _: { };

          "Mod+Shift+Left".move-column-left = _: { };
          "Mod+Shift+Right".move-column-right = _: { };
          "Mod+Shift+Up".move-window-up = _: { };
          "Mod+Shift+Down".move-window-down = _: { };
          "Mod+Shift+J".move-column-left = _: { };
          "Mod+Shift+L".move-column-right = _: { };
          "Mod+Shift+I".move-window-up = _: { };
          "Mod+Shift+K".move-window-down = _: { };

          "Mod+Ctrl+Left".focus-monitor-left = _: { };
          "Mod+Ctrl+Right".focus-monitor-right = _: { };
          "Mod+U".focus-monitor-left = _: { };
          "Mod+O".focus-monitor-right = _: { };
          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: { };
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: { };
          "Mod+Shift+U".move-column-to-monitor-left = _: { };
          "Mod+Shift+O".move-column-to-monitor-right = _: { };

          "Mod+Page_Down".focus-workspace-down = _: { };
          "Mod+Page_Up".focus-workspace-up = _: { };
          "Mod+Shift+Page_Down".move-column-to-workspace-down = _: { };
          "Mod+Shift+Page_Up".move-column-to-workspace-up = _: { };

          "Mod+BracketLeft".consume-or-expel-window-left = _: { };
          "Mod+BracketRight".consume-or-expel-window-right = _: { };

          "Mod+S".switch-preset-column-width = _: { };
          "Mod+Shift+S".fullscreen-window = _: { };
          "Mod+D".center-column = _: { };
          "Mod+Shift+D".toggle-window-floating = _: { };
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";

          "Print".screenshot = _: { };
          "Mod+4".screenshot = _: { };
          "Ctrl+Print".screenshot-screen = _: { };
          "Alt+Print".screenshot-window = _: { };

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "Mod+Shift+A".quit = _: { };
          "Mod+Shift+P".power-off-monitors = _: { };
        };
      };
    };
  };
}
