{ ... }: {
  flake.nixosModules.zsh = { ... }: {
    programs.zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ ];
        theme = "agnoster";
      };
    };
  };
}
