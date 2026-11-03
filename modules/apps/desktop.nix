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
      # exclusive_caps=1 makes Chromium/Electron apps (Discord, browsers) list
      # the loopback as a camera; the label replaces "Dummy video device".
      boot.extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="DroidCam"
      '';
    };
  };
}
