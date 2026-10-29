{ ... }: {
  flake.nixosModules.networkmanager = { ... }: {
    # Enable networking
    networking.networkmanager.enable = true;
  };
}
