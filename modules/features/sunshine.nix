{ ... }: {
  flake.nixosModules.sunshine = { pkgs, ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      # CUDA lets captured frames go straight to NVENC on the GPU instead of
      # falling back to a slow CPU copy / software encode.
      package = pkgs.sunshine.override { cudaSupport = true; };
      # Setting anything here makes the web UI's config page read-only;
      # pairing still happens in the UI (https://localhost:47990).
      settings = {
        # Without a fixed method Sunshine probes the screencast portal first,
        # which pops up niri's "pick a screen" dialog at every login. niri
        # supports wlr-screencopy, so use that directly.
        capture = "wlr";
        # Index in Sunshine's Wayland monitor list (see its log at startup);
        # 0 is the Gigabyte (DP-3), the main monitor.
        output_name = 0;
      };
    };
  };
}
