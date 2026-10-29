{ ... }: {
  flake.nixosModules.appsSocial = { config, lib, pkgs, ... }: {
    options.apps.social.enable = lib.mkEnableOption "chat and media apps (discord, spotify)";

    config = lib.mkIf config.apps.social.enable {
      environment.systemPackages = with pkgs; [
        discord
        spotify
      ];
    };
  };
}
