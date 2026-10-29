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
      };
      "GIGA-BYTE TECHNOLOGY CO., LTD. G27QC 0x00000443" = {
        width = 2560;
        height = 1440;
        refresh = 164.802;
        x = 2560;
        vrr = "on-demand";
        primary = true;
      };
      # Physically rotated 90° counter-clockwise, so 1080 wide in the layout.
      "Iiyama North America PL2488H 0x01010101" = {
        width = 1920;
        height = 1080;
        refresh = 74.973;
        x = 5120;
        transform = "270";
      };
    };
  };
}
