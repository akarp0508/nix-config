{ ... }: {
  # Baseline CLI tools, wanted on pretty much every machine.
  flake.nixosModules.appsCore = { config, lib, pkgs, ... }: {
    options.apps.core.enable = lib.mkEnableOption "core CLI tools (vim, git, wget, curl, htop, kitty)";

    config = lib.mkIf config.apps.core.enable {
      environment.systemPackages = with pkgs; [
        vim
        git
        wget
        curl
        htop
        kitty
      ];
    };
  };
}
