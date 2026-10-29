{ ... }: {
  flake.nixosModules.kitty = { pkgs, lib, ... }:
  let
    fastfetchGreen = lib.concatStringsSep " " (
      [ "${lib.getExe pkgs.fastfetch}" "--color" "green" "--structure-disabled" "colors" ]
      ++ lib.concatMap (n: [ "--logo-color-${toString n}" "green" ]) (lib.range 1 9)
    );

    shell = pkgs.writeShellScript "kitty-shell" ''
      ${fastfetchGreen}
      exec "$SHELL"
    '';
  in
  {
    environment.etc."xdg/kitty/kitty.conf".text = ''
      # No window titlebar/decorations.
      hide_window_decorations yes

      # Slightly translucent background.
      background_opacity 0.85

      # Greet with an all-green fastfetch, kitty only, then drop into the
      # normal shell.
      shell ${shell}
    '';
  };
}
