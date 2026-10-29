{ self, inputs, ... }: {

  flake.nixosModules.desktopConfiguration = { config, pkgs, ... }:

  {
    imports =
      [
        self.nixosModules.desktopHardware
        self.nixosModules.niri
        self.nixosModules.zsh
        self.nixosModules.nvidia
        self.nixosModules.gnomeDesktop
        self.nixosModules.audio
        self.nixosModules.printing
        self.nixosModules.nixSettings
        self.nixosModules.locale
        self.nixosModules.appsCore
        self.nixosModules.appsDev
        self.nixosModules.appsBrowsers
        self.nixosModules.appsGaming
      ];

    # Left to right: Samsung | Gigabyte | Iiyama (portrait).
    # Keyed by make/model/serial so they survive swapping ports (DP-1 / DP-3 / HDMI-A-1 now).
    monitors = {
      "Samsung Electric Company C27JG5x HTOKA00805" = {
        width = 2560;
        height = 1440;
        refresh = 143.998;
        x = 0;
      };
      "GIGA-BYTE TECHNOLOGY CO., LTD. G27QC 0x00000443" = {
        width = 2560;
        height = 1440;
        refresh = 164.802;
        x = 2560;
        vrr = "on-demand";
        primary = true;
      };
      # Physically rotated 90° counter-clockwise, so 1080 wide in the layout.
      "Iiyama North America PL2488H 0x01010101" = {
        width = 1920;
        height = 1080;
        refresh = 74.973;
        x = 5120;
        transform = "270";
      };
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixDesktop"; # Matches nixosConfigurations.nixDesktop.

    # Enable networking
    networking.networkmanager.enable = true;

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
