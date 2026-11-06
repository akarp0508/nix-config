{ ... }: {
  flake.nixosModules.openrgb = { config, lib, pkgs, ... }: let
    sleepTargets = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
  in {
    # Enables i2c/SMBus access (udev rules, i2c-dev) for RAM/motherboard RGB;
    # motherboard is AMD, so the amd variant loads the right SMBus driver.
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
      package = pkgs.openrgb-with-all-plugins;
    };

    # The module has no profile option; load the saved "green" profile
    # (/var/lib/OpenRGB/profiles) every time the server starts.
    systemd.services.openrgb.serviceConfig.ExecStart = lib.mkForce
      "${config.services.hardware.openrgb.package}/bin/openrgb --server --server-port ${toString config.services.hardware.openrgb.server.port} --profile green";

    # Devices reset to their firmware default on resume; restarting the server
    # re-detects them and reapplies the profile. Ordered After= the sleep
    # targets, so it only runs once the system wakes up.
    systemd.services.openrgb-resume = {
      description = "Reapply OpenRGB profile after resume";
      after = sleepTargets;
      wantedBy = sleepTargets;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl restart openrgb.service";
      };
    };
  };
}
