{ self, ... }: {
  flake.nixosModules.noctaliaGreeter = { config, pkgs, lib, ... }:
  let
    cfg = config.noctaliaGreeter;

    # The login panel is hard-centred in 1.7.0 (no config key), covering the
    # middle of the wallpaper; push it towards the bottom instead.
    package = pkgs.noctalia-greeter.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace src/greeter/greeter_surface.cpp \
          --replace-fail "std::round((sh - panelHeight) * 0.5f)" "std::round((sh - panelHeight) * 0.85f)"
      '';
    });

    # onSurfaceVariant -> on_surface_variant
    toSnakeCase = name: lib.concatMapStrings
      (c: if lib.toLower c != c then "_" + lib.toLower c else c)
      (lib.stringToCharacters name);

    # Declarative greeter.toml. It always wins over the greeter's own
    # sync.toml, so `noctalia msg greeter-sync` can't fight it.
    settings = lib.recursiveUpdate {
      session.default = "niri";

      appearance = {
        scheme = "Synced";
        theme_mode = "dark";
        # Its spot at the bottom centre is taken by the lowered login panel.
        hide_logo = true;
        # Same colors as the noctalia shell (modules/features/noctalia.nix).
        palette = lib.mapAttrs' (name: lib.nameValuePair (toSnakeCase name)) self.lib.colors;
      } // lib.optionalAttrs (config ? wallpaper && config.wallpaper != null) {
        wallpaper = {
          path = "${config.wallpaper}";
          fill_mode = "crop";
          fill_color = "#000000";
        };
      };

      clock = {
        time_format = "{:%H:%M}";
        date_format = "{:%a, %b %d}";
      };

      # Match the niri session (niri.nix).
      cursor = {
        theme = "Bibata-Modern-Classic";
        size = 22;
        path = "/run/current-system/sw/share/icons";
      };
      keyboard.layout = "pl";

      output = lib.filterAttrs (_: v: v != null) {
        layout = cfg.outputLayout;
        transforms = cfg.outputTransforms;
      };
    } cfg.settings;
  in
  {
    # noctalia-greeter only reliably enables a single output unless told
    # about the rest, so multi-monitor hosts need to set these to match
    # their real layout (see noctalia-greeter's greeter.toml [output] docs:
    # layout = "CONNECTOR:X,Y; ..."; transforms = "CONNECTOR:90; ...").
    options.noctaliaGreeter = {
      outputLayout = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Raw value for greeter.toml's [output] "layout" key, e.g.
          "DP-1:0,0; DP-3:2560,0; HDMI-A-1:5120,0". Keyed by connector name
          (not make/model/serial), since that's what noctalia-greeter matches
          against.
        '';
      };
      outputTransforms = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Raw value for greeter.toml's [output] "transforms" key, e.g.
          "HDMI-A-1:270".
        '';
      };
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Extra greeter.toml settings, merged over the defaults above.";
      };
    };

    config = {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = lib.getExe' package "noctalia-greeter-session";
          user = "greeter";
        };
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/noctalia-greeter 0750 greeter greeter - -"
        "L+ /var/lib/noctalia-greeter/greeter.toml - - - - ${(pkgs.formats.toml { }).generate "greeter.toml" settings}"
      ];
    };
  };
}
