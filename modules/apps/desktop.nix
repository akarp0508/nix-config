{ ... }: {
  flake.nixosModules.appsDesktop = { config, lib, pkgs, ... }: {
    options.apps.desktop.enable = lib.mkEnableOption "general desktop apps (file manager, calculator, image viewer, video player, office suite, notes, system monitor, phone webcam)";

    config = lib.mkIf config.apps.desktop.enable {
      environment.systemPackages = with pkgs; [
        nautilus
        gnome-calculator
        loupe
        mpv
        libreoffice
        obsidian
        mission-center
      ];

      # Nautilus needs gvfs to list drives and udisks2 to mount them without
      # sudo. Mounting internal drives asks for the admin password via the
      # polkit agent (noctalia's).
      services.gvfs.enable = true;
      services.udisks2.enable = true;

      # Installs DroidCam and loads the v4l2loopback kernel module it needs
      # to expose the phone as a virtual webcam.
      programs.droidcam.enable = true;
    };
  };
}
