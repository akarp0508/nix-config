{ self, inputs, ... }: {

  flake.nixosModules.desktopConfiguration = { config, pkgs, ... }:

  {
    imports =
      [
        self.nixosModules.base
        self.nixosModules.desktopHardware
        self.nixosModules.desktopMonitors
        self.nixosModules.niri
        self.nixosModules.nvidia
        self.nixosModules.noctaliaGreeter
        self.nixosModules.kitty
        self.nixosModules.appsCore
        self.nixosModules.appsDev
        self.nixosModules.appsBrowsers
        self.nixosModules.appsGaming
        self.nixosModules.appsSocial
      ];

    networking.hostName = "nixDesktop"; # Matches nixosConfigurations.nixDesktop.

    users.users."akarp0508" = {
      isNormalUser = true;
      description = "akarp0508";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };

    apps.core.enable = true;
    apps.dev.enable = true;
    apps.browsers.enable = true;
    apps.gaming.enable = true;
    apps.social.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

  };
}
