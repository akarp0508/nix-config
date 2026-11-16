{ ... }: {
  flake.nixosModules.networkmanager = { ... }: {
    networking.networkmanager.enable = true;

    # Resolve .local names (e.g. koiclock.local) in browsers, ping, curl.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
    };
  };
}
