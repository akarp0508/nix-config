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
        self.nixosModules.appsDesktop
        self.nixosModules.appsCad
        self.nixosModules.syncthing
        self.nixosModules.sunshine
        self.nixosModules.theming
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
    apps.desktop.enable = true;
    apps.cad.enable = true;

    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];

    system.stateVersion = "26.05";

  };
}
