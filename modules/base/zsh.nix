{ ... }: {
  flake.nixosModules.zsh = { ... }: {
    programs.zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "agnoster";
      };

      shellAliases = {
        renix = "sudo nixos-rebuild switch --flake /home/akarp0508/.nixos-dendritic";
        c = "claude";
        cr = "claude --resume";

        py = "python3";
        uvr = "uv run";
        uva = "uv add";
        uvs = "uv sync";
        uvv = "uv venv";
      };
    };
  };
}
