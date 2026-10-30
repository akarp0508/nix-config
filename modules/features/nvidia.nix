{ ... }: {
  flake.nixosModules.nvidia = { ... }: {
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Required for Wayland.
      modesetting.enable = true;

      # Preserves VRAM across suspend; without it, resuming from a long
      # suspend can corrupt GPU state (NVRM Xid 13) and hang the system.
      powerManagement.enable = true;

      # Turns off the GPU when not in use. Set to true on laptops.
      powerManagement.finegrained = false;

      # Recommended for Turing and newer.
      open = true;

      nvidiaSettings = true;
    };
  };
}
