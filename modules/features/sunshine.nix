{ ... }: {
  flake.nixosModules.sunshine = { pkgs, ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      # KMS capture needs CAP_SYS_ADMIN; it's the only capture method that
      # works reliably on niri with the NVIDIA driver.
      capSysAdmin = true;
      openFirewall = true;
      # CUDA lets KMS-captured frames go straight to NVENC on the GPU instead
      # of falling back to a slow CPU copy / software encode.
      package = pkgs.sunshine.override { cudaSupport = true; };
      # Settings and apps are left to the web UI (https://localhost:47990);
      # setting either here would make the UI read-only.
    };
  };
}
