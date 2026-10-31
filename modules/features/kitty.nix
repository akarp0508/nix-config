{ self, ... }: {
  flake.nixosModules.kitty = { pkgs, lib, ... }:
  let
    t = self.lib.terminalColors;

    ansi = [ "black" "red" "green" "yellow" "blue" "magenta" "cyan" "white" ];
    colorLines = lib.concatStrings (lib.imap0
      (i: name: ''
        color${toString i} ${t.normal.${name}}
        color${toString (i + 8)} ${t.bright.${name}}
      '')
      ansi);

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
      font_family JetBrainsMono Nerd Font
      font_size 11.0

      # No window titlebar/decorations.
      hide_window_decorations yes

      # Slightly translucent background.
      background_opacity 0.85
      window_padding_width 6

      # Same palette as the noctalia shell.
      foreground ${t.foreground}
      background ${t.background}
      cursor ${t.cursor}
      cursor_text_color ${t.cursorText}
      selection_foreground ${t.selectionFg}
      selection_background ${t.selectionBg}
      url_color ${t.bright.cyan}
      ${colorLines}
      # Greet with an all-green fastfetch, kitty only, then drop into the
      # normal shell.
      shell ${shell}
    '';
  };
}
