{ ... }: {
  flake.nixosModules.nvidia = { ... }: {
    hardware.graphics.enable = true;

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Saves the entire VRAM on suspend. Enable if you get graphical corruption
      # or application crashes after waking up from sleep.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use (laptops).
      powerManagement.finegrained = false;

      # Use the NVIDIA open kernel module (recommended for Turing and newer).
      open = true;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = true;
    };
  };
}
