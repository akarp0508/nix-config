{ self, ... }:
let
  # The one color scheme for the whole desktop: noctalia, its greeter, GTK/Qt,
  # kitty, the prompt, btop. Change it here and everything follows.
  colors = {
    primary = "#39FF14";
    onPrimary = "#000000";
    secondary = "#22C55E";
    onSecondary = "#000000";
    tertiary = "#86EFAC";
    onTertiary = "#000000";
    error = "#FF4444";
    onError = "#000000";
    surface = "#000000";
    onSurface = "#E8FFE8";
    surfaceVariant = "#101810";
    onSurfaceVariant = "#7FBF8F";
    outline = "#1F4D2E";
    shadow = "#000000";
    hover = "#4AFF2E";
    onHover = "#000000";
  };

  # ANSI terminal palette in the same scheme. Shared with kitty, btop etc.
  terminal = {
    background = "#000000";
    foreground = "#E8FFE8";
    cursor = "#39FF14";
    cursorText = "#000000";
    selectionBg = "#1F4D2E";
    selectionFg = "#E8FFE8";
    normal = {
      black = "#101810"; red = "#FF4444"; green = "#22C55E"; yellow = "#D4E157";
      blue = "#26A69A"; magenta = "#9CCC65"; cyan = "#4DD0B1"; white = "#7FBF8F";
    };
    bright = {
      black = "#1F4D2E"; red = "#FF6B6B"; green = "#39FF14"; yellow = "#EEFF41";
      blue = "#64FFDA"; magenta = "#B2FF59"; cyan = "#86EFAC"; white = "#E8FFE8";
    };
  };
in
{
  flake.lib.colors = colors;
  flake.lib.terminalColors = terminal;

  # System-wide look for everything outside the noctalia shell: GTK/Qt apps,
  # cursor and fonts.
  flake.nixosModules.theming = { pkgs, lib, ... }:
  let
    c = colors;

    cursor = { theme = "Bibata-Modern-Classic"; size = 22; };
    monoFont = "JetBrainsMono Nerd Font";

    # libadwaita (GTK4) reads named colors from ~/.config/gtk-4.0/gtk.css.
    # Newer versions use the CSS variables, older ones @define-color, so set
    # both.
    adwColors = {
      accent_bg_color = c.primary;
      accent_fg_color = c.onPrimary;
      accent_color = c.primary;
      destructive_bg_color = c.error;
      destructive_fg_color = c.onError;
      destructive_color = c.error;
      window_bg_color = c.surface;
      window_fg_color = c.onSurface;
      view_bg_color = c.surface;
      view_fg_color = c.onSurface;
      headerbar_bg_color = c.surface;
      headerbar_fg_color = c.onSurface;
      headerbar_backdrop_color = c.surface;
      headerbar_border_color = c.outline;
      sidebar_bg_color = c.surfaceVariant;
      sidebar_fg_color = c.onSurface;
      sidebar_backdrop_color = c.surfaceVariant;
      secondary_sidebar_bg_color = c.surfaceVariant;
      secondary_sidebar_fg_color = c.onSurface;
      card_bg_color = c.surfaceVariant;
      card_fg_color = c.onSurface;
      dialog_bg_color = c.surfaceVariant;
      dialog_fg_color = c.onSurface;
      popover_bg_color = c.surfaceVariant;
      popover_fg_color = c.onSurface;
      thumbnail_bg_color = c.surfaceVariant;
      thumbnail_fg_color = c.onSurface;
    };

    gtk4Css = pkgs.writeText "gtk4.css" ''
      ${lib.concatStrings (lib.mapAttrsToList (n: v: "@define-color ${n} ${v};\n") adwColors)}
      :root {
      ${lib.concatStrings (lib.mapAttrsToList (n: v: "  --${lib.replaceStrings [ "_" ] [ "-" ] n}: ${v};\n") adwColors)}}
    '';

    # GTK3 Adwaita-dark only partially honours these, but it's enough to
    # pull the stray GTK3 app into the same colors.
    gtk3Css = pkgs.writeText "gtk3.css" ''
      @define-color theme_bg_color ${c.surface};
      @define-color theme_fg_color ${c.onSurface};
      @define-color theme_base_color ${c.surface};
      @define-color theme_text_color ${c.onSurface};
      @define-color theme_selected_bg_color ${c.primary};
      @define-color theme_selected_fg_color ${c.onPrimary};
      @define-color borders ${c.outline};
    '';

    settingsIni = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme-name=${cursor.theme}
      gtk-cursor-theme-size=${toString cursor.size}
    '';
  in
  {
    fonts = {
      packages = [ pkgs.nerd-fonts.jetbrains-mono ];
      fontconfig.defaultFonts.monospace = [ monoFont ];
    };

    environment.systemPackages = [ pkgs.bibata-cursors ];
    environment.variables = {
      XCURSOR_THEME = cursor.theme;
      XCURSOR_SIZE = toString cursor.size;
    };

    # Defaults for GTK/libadwaita (via the settings portal); still
    # changeable per user with gsettings.
    programs.dconf = {
      enable = true;
      profiles.user.databases = [{
        settings."org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          cursor-theme = cursor.theme;
          cursor-size = lib.gvariant.mkInt32 cursor.size;
          monospace-font-name = "${monoFont} 11";
        };
      }];
    };

    # Fallback for GTK apps that don't go through dconf.
    environment.etc."xdg/gtk-3.0/settings.ini".text = settingsIni;
    environment.etc."xdg/gtk-4.0/settings.ini".text = settingsIni;

    # GTK only loads gtk.css from the user's config dir, so link the
    # generated ones in there.
    systemd.user.tmpfiles.users.akarp0508.rules = [
      "L+ %h/.config/gtk-4.0/gtk.css - - - - ${gtk4Css}"
      "L+ %h/.config/gtk-3.0/gtk.css - - - - ${gtk3Css}"
    ];

    # Qt apps follow the dark Adwaita look.
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };
  };
}
