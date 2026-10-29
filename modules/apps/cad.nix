{ ... }: {
  flake.nixosModules.appsCad = { config, lib, pkgs, ... }: {
    options.apps.cad.enable = lib.mkEnableOption "CAD / 3D-printing tools (FreeCAD, Cura, PrusaSlicer)";

    config = lib.mkIf config.apps.cad.enable {
      environment.systemPackages = with pkgs; [
        freecad
        cura-appimage
        prusa-slicer
      ];
    };
  };
}
