{ ... }: {
  # Compositor-agnostic monitor layout. Hosts set `monitors`, compositor
  # modules (e.g. niri) translate it into their own config.
  flake.nixosModules.monitors = { lib, ... }: {
    options.monitors = lib.mkOption {
      default = { };
      description = "Monitors keyed by output name (connector like \"DP-3\" or \"Make Model Serial\").";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          width = lib.mkOption { type = lib.types.int; };
          height = lib.mkOption { type = lib.types.int; };
          refresh = lib.mkOption {
            type = lib.types.nullOr lib.types.float;
            default = null;
            description = "Refresh rate in Hz, as listed by the compositor (e.g. 164.802). null picks the preferred one.";
          };
          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
          };
          transform = lib.mkOption {
            type = lib.types.enum [ "normal" "90" "180" "270" "flipped" "flipped-90" "flipped-180" "flipped-270" ];
            default = "normal";
            description = "Counter-clockwise content rotation. A monitor physically turned 90° counter-clockwise needs \"270\".";
          };
          vrr = lib.mkOption {
            type = lib.types.enum [ "off" "on" "on-demand" ];
            default = "off";
            description = "Variable refresh rate. on-demand only enables it for windows that request it.";
          };
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Focus this monitor at startup.";
          };
          workspaces = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = ''
              Named workspaces pinned to this output, in order. Pinned
              workspaces always exist (even empty), giving a fixed per-monitor
              workspace count instead of niri's default dynamic ones. Names
              must be unique across all monitors. Empty list keeps the
              default dynamic behaviour for this output.
            '';
          };
        };
      });
    };
  };
}
