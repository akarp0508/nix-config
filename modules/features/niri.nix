{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs; # THIS PART IS VERY IMPORTANT, I FORGOT IT IN THE VIDEO!!!
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb.layout = "pl";

        layout.gaps = 5;

        # The generated config replaces niri's default one, so every bind has to be listed here.
        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = _: { };

          "Mod+Return".spawn = lib.getExe pkgs.kitty;
          "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+Q".close-window = _: { };
          "Mod+O".toggle-overview = _: { };

          "Mod+Left".focus-column-left = _: { };
          "Mod+Right".focus-column-right = _: { };
          "Mod+Up".focus-window-up = _: { };
          "Mod+Down".focus-window-down = _: { };
          "Mod+H".focus-column-left = _: { };
          "Mod+L".focus-column-right = _: { };
          "Mod+K".focus-window-up = _: { };
          "Mod+J".focus-window-down = _: { };

          "Mod+Shift+Left".move-column-left = _: { };
          "Mod+Shift+Right".move-column-right = _: { };
          "Mod+Shift+Up".move-window-up = _: { };
          "Mod+Shift+Down".move-window-down = _: { };
          "Mod+Shift+H".move-column-left = _: { };
          "Mod+Shift+L".move-column-right = _: { };
          "Mod+Shift+K".move-window-up = _: { };
          "Mod+Shift+J".move-window-down = _: { };

          "Mod+Ctrl+Left".focus-monitor-left = _: { };
          "Mod+Ctrl+Right".focus-monitor-right = _: { };
          "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: { };
          "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: { };

          "Mod+Page_Down".focus-workspace-down = _: { };
          "Mod+Page_Up".focus-workspace-up = _: { };
          "Mod+Shift+Page_Down".move-column-to-workspace-down = _: { };
          "Mod+Shift+Page_Up".move-column-to-workspace-up = _: { };

          "Mod+BracketLeft".consume-or-expel-window-left = _: { };
          "Mod+BracketRight".consume-or-expel-window-right = _: { };

          "Mod+R".switch-preset-column-width = _: { };
          "Mod+F".maximize-column = _: { };
          "Mod+Shift+F".fullscreen-window = _: { };
          "Mod+C".center-column = _: { };
          "Mod+V".toggle-window-floating = _: { };
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";

          "Print".screenshot = _: { };
          "Ctrl+Print".screenshot-screen = _: { };
          "Alt+Print".screenshot-window = _: { };

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "Mod+Shift+E".quit = _: { };
          "Mod+Shift+P".power-off-monitors = _: { };
        }
        // lib.listToAttrs (lib.concatMap (n: [
          (lib.nameValuePair "Mod+${toString n}" { focus-workspace = n; })
          (lib.nameValuePair "Mod+Shift+${toString n}" { move-column-to-workspace = n; })
        ]) (lib.range 1 9));
      };
    };
  };
}
