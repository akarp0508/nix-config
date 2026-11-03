{ ... }: {
  flake.nixosModules.openrgb = { pkgs, ... }: {
    # Enables i2c/SMBus access (udev rules, i2c-dev) for RAM/motherboard RGB;
    # motherboard is AMD, so the amd variant loads the right SMBus driver.
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
      package = pkgs.openrgb-with-all-plugins;
    };
  };
}
