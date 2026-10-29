{ ... }: {
  # Wallpaper image for the desktop. Applied by the shell at session startup.
  flake.nixosModules.wallpaper = { lib, ... }: {
    options.wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper image, set on all monitors at login.";
    };
  };
}
