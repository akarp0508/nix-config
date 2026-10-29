{ ... }: {
  flake.nixosModules.appsBrowsers = { config, lib, ... }: {
    options.apps.browsers.enable = lib.mkEnableOption "web browsers (firefox)";

    config = lib.mkIf config.apps.browsers.enable {
      programs.firefox.enable = true;
    };
  };
}
