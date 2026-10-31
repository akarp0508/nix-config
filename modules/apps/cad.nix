{ ... }: {
  flake.nixosModules.appsCad = { config, lib, pkgs, ... }: {
    options.apps.cad.enable = lib.mkEnableOption "CAD / 3D-printing tools (FreeCAD, OpenSCAD, KiCad, Cura, PrusaSlicer)";

    config = lib.mkIf config.apps.cad.enable {
      environment.systemPackages = with pkgs; [
        freecad
        openscad
        kicad
        cura-appimage
        prusa-slicer
      ];
    };
  };
}
