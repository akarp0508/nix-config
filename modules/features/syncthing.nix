{ ... }: {
  flake.nixosModules.syncthing = { ... }: {
    services.syncthing = {
      enable = true;
      user = "akarp0508";
      # The default /var/lib/syncthing is only created for the dedicated
      # syncthing user; running as a normal user needs a dir it can write.
      dataDir = "/home/akarp0508";
      configDir = "/home/akarp0508/.config/syncthing";
      openDefaultPorts = true;
      # Folders/devices are managed via the web UI (127.0.0.1:8384), not here.
    };
  };
}
