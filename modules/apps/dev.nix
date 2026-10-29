{ ... }: {
  # Development tooling.
  flake.nixosModules.appsDev = { config, lib, pkgs, ... }: {
    options.apps.dev.enable = lib.mkEnableOption "development tools (zed-editor, claude-code, home-manager)";

    config = lib.mkIf config.apps.dev.enable {
      environment.systemPackages = with pkgs; [
        zed-editor
        claude-code
        home-manager
      ];
    };
  };
}
