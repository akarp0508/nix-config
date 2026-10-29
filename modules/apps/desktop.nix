{ ... }: {
  flake.nixosModules.appsDesktop = { config, lib, pkgs, ... }: {
    options.apps.desktop.enable = lib.mkEnableOption "general desktop apps (file manager, calculator, image viewer, video player, office suite, notes, system monitor)";

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
    };
  };
}
