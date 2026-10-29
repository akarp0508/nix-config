{ ... }: {
  flake.nixosModules.appsGaming = { config, lib, pkgs, ... }: {
    options.apps.gaming.enable = lib.mkEnableOption "gaming (steam, heroic)";

    config = lib.mkIf config.apps.gaming.enable {
      programs.steam.enable = true;
      programs.gamemode.enable = true;
      environment.systemPackages = [ pkgs.heroic ];
    };
  };
}
