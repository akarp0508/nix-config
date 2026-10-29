{ ... }: {
  flake.nixosModules.zsh = { ... }: {
    programs.zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ ];
        theme = "agnoster";
      };

      shellAliases = {
        renix = "sudo nixos-rebuild switch --flake /home/akarp0508/.nixos-dendritic";
        c = "claude";
        cr = "claude --resume";
      };
    };
  };
}
