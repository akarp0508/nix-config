{ ... }: {
  flake.nixosModules.desktopMonitors = { ... }: {
    # Left to right: Samsung | Gigabyte | Iiyama (portrait).
    # Keyed by make/model/serial so they survive swapping ports (DP-1 / DP-3 / HDMI-A-1 now).
    monitors = {
      "Samsung Electric Company C27JG5x HTOKA00805" = {
        width = 2560;
        height = 1440;
        refresh = 143.998;
        x = 0;
        workspaces = [ "L1" "L2" "L3" ];
      };
      "GIGA-BYTE TECHNOLOGY CO., LTD. G27QC 0x00000443" = {
        width = 2560;
        height = 1440;
        refresh = 164.802;
        x = 2560;
        vrr = "on-demand";
        primary = true;
        workspaces = [ "M1" "M2" "M3" "M4" "M5" "M6" ];
      };
      # Physically rotated 90° counter-clockwise, so 1080 wide in the layout.
      "iiyama Corporation PL2488H 0x01010101" = {
        width = 1920;
        height = 1080;
        refresh = 74.973;
        x = 5120;
        # Vertically centred on the Gigabyte: (1440 - 1920) / 2.
        y = -240;
        transform = "270";
        workspaces = [ "R1" "R2" "R3" ];
      };
    };

    # noctalia-greeter matches by connector, not make/model/serial, so this
    # needs re-syncing (via `niri msg outputs`) if ports get swapped again.
    noctaliaGreeter = {
      outputLayout = "DP-1:0,0; DP-3:2560,0; HDMI-A-1:5120,-240";
      outputTransforms = "HDMI-A-1:270";
    };
  };
}
