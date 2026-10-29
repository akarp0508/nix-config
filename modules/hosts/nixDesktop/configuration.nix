{ self, inputs, ... }: {

  flake.nixosModules.desktopConfiguration = { config, pkgs, ... }:

  {
    imports =
      [
        self.nixosModules.desktopHardware
        self.nixosModules.niri
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

    wallpaper = ./wallpaper.png;

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # NVIDIA (RTX 3080, Ampere)
    hardware.graphics.enable = true;

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Saves the entire VRAM on suspend. Enable if you get graphical corruption
      # or application crashes after waking up from sleep.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use (laptops).
      powerManagement.finegrained = false;

      # Use the NVIDIA open kernel module (recommended for Turing and newer).
      open = true;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
      nvidiaSettings = true;
    };

    networking.hostName = "nixDesktop"; # Matches nixosConfigurations.nixDesktop.

    # Enable networking
    networking.networkmanager.enable = true;

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };

    # Enable zsh
    programs.zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ ];
        theme = "agnoster";
      };
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "pl2";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    users.users."akarp0508" = {
      isNormalUser = true;
      description = "akarp0508";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };

    programs.firefox.enable = true;

    programs.steam.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      curl
      htop
      kitty
      home-manager
      zed-editor
      heroic
      claude-code
    ];

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
