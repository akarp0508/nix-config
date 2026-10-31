{ ... }: {
  flake.nixosModules.appsBrowsers = { config, lib, pkgs, ... }: {
    options.apps.browsers.enable = lib.mkEnableOption "web browsers (firefox, brave)";

    config = lib.mkIf config.apps.browsers.enable {
      programs.firefox.enable = true;
      environment.systemPackages = [ pkgs.brave ];
    };
  };
}
