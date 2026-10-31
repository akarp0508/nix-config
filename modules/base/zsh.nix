{ self, ... }: {
  flake.nixosModules.zsh = { pkgs, lib, ... }:
  let
    c = self.lib.colors;
    t = self.lib.terminalColors;

    # btop rewrites its config on exit, so point it at a read-only one with
    # saving off; the theme lives next to it.
    btopTheme = pkgs.writeText "neon.theme" ''
      theme[main_bg]="${t.background}"
      theme[main_fg]="${t.foreground}"
      theme[title]="${c.primary}"
      theme[hi_fg]="${c.primary}"
      theme[selected_bg]="${c.outline}"
      theme[selected_fg]="${t.foreground}"
      theme[inactive_fg]="${c.onSurfaceVariant}"
      theme[graph_text]="${c.onSurfaceVariant}"
      theme[meter_bg]="${c.surfaceVariant}"
      theme[proc_misc]="${c.tertiary}"
      theme[cpu_box]="${c.outline}"
      theme[mem_box]="${c.outline}"
      theme[net_box]="${c.outline}"
      theme[proc_box]="${c.outline}"
      theme[div_line]="${c.outline}"
      theme[temp_start]="${c.secondary}"
      theme[temp_mid]="${t.normal.yellow}"
      theme[temp_end]="${c.error}"
      theme[cpu_start]="${c.secondary}"
      theme[cpu_mid]="${c.primary}"
      theme[cpu_end]="${t.bright.yellow}"
      theme[free_start]="${c.outline}"
      theme[free_mid]="${c.secondary}"
      theme[free_end]="${c.primary}"
      theme[cached_start]="${c.outline}"
      theme[cached_mid]="${t.normal.cyan}"
      theme[cached_end]="${t.bright.cyan}"
      theme[available_start]="${c.outline}"
      theme[available_mid]="${c.secondary}"
      theme[available_end]="${c.tertiary}"
      theme[used_start]="${c.secondary}"
      theme[used_mid]="${c.primary}"
      theme[used_end]="${t.bright.yellow}"
      theme[download_start]="${c.outline}"
      theme[download_mid]="${c.secondary}"
      theme[download_end]="${c.primary}"
      theme[upload_start]="${c.outline}"
      theme[upload_mid]="${t.normal.cyan}"
      theme[upload_end]="${t.bright.cyan}"
      theme[process_start]="${c.secondary}"
      theme[process_mid]="${c.primary}"
      theme[process_end]="${t.bright.yellow}"
    '';
    btopThemes = pkgs.linkFarm "btop-themes" { "neon.theme" = btopTheme; };
    btopConf = pkgs.writeText "btop.conf" ''
      color_theme = "neon"
      theme_background = False
      truecolor = True
      rounded_corners = True
      save_config_on_exit = False
    '';
    btop = pkgs.symlinkJoin {
      name = "btop-neon";
      paths = [ pkgs.btop ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/btop \
          --add-flags "--config ${btopConf} --themes-dir ${btopThemes}"
      '';
    };
  in
  {
    programs.zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
        # Prompt comes from starship instead.
        theme = "";
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

        ls = "eza --icons=auto --group-directories-first";
        ll = "eza -l --icons=auto --group-directories-first --git";
        la = "eza -la --icons=auto --group-directories-first --git";
        lt = "eza --tree --icons=auto --level=2";
        cat = "bat --paging=never --style=plain";
      };
    };

    environment.systemPackages = [ btop pkgs.eza pkgs.bat ];

    environment.variables = {
      # Uses the terminal's own ANSI colors, i.e. kitty's neon palette.
      BAT_THEME = "ansi";
      # eza: directories bright green, symlinks cyan, executables yellow.
      EZA_COLORS = "di=1;92:ln=96:ex=1;93:da=32:uu=92:gu=32:sn=32:sb=32";
    };

    # agnoster-style powerline prompt: status, user@host, dir, git.
    programs.starship = {
      enable = true;
      settings =
      let
        ctx = c.surfaceVariant;
        dir = c.primary;
        git = c.secondary;
      in
      {
        add_newline = false;
        format = lib.concatStrings [
          "[ ](bg:${ctx})$status$jobs$username$hostname"
          "[](fg:${ctx} bg:${dir})$directory"
          # Only one of these two shows: the arrow into the git segment or,
          # outside a repo, the closing arrow after the directory.
          "($git_branch$git_status[](fg:${git}) )"
          "\${custom.dir_end}"
        ];
        status = {
          disabled = false;
          format = "[✘ ](fg:${c.error} bg:${ctx})";
        };
        jobs = {
          symbol = "⚙";
          format = "[$symbol ](fg:${c.tertiary} bg:${ctx})";
        };
        username = {
          show_always = true;
          style_user = "fg:${c.onSurface} bg:${ctx}";
          style_root = "fg:${c.error} bg:${ctx}";
          format = "[$user]($style)";
        };
        hostname = {
          ssh_only = false;
          format = "[@$hostname ](fg:${c.onSurface} bg:${ctx})";
        };
        directory = {
          truncation_length = 100;
          truncate_to_repo = false;
          read_only = " ";
          format = "[ $path$read_only ](fg:${c.onPrimary} bg:${dir})";
        };
        git_branch.format = "[](fg:${dir} bg:${git})[  $branch ](fg:${c.onSecondary} bg:${git})";
        git_status = {
          format = "[($all_status$ahead_behind )](fg:${c.onSecondary} bg:${git})";
        };
        custom.dir_end = {
          when = "! git rev-parse --is-inside-work-tree >/dev/null 2>&1";
          format = "[ ](fg:${dir})";
        };
      };
    };
  };
}
