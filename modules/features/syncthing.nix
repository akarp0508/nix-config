{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "akarp0508";
      openDefaultPorts = true;
      # Folders/devices are managed via the web UI (127.0.0.1:8384), not here.
    };
  };
}
