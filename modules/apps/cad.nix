{ ... }: {
  flake.nixosModules.appsCad = { config, lib, pkgs, ... }: {
    options.apps.cad.enable = lib.mkEnableOption "CAD / 3D-printing tools (FreeCAD, OpenSCAD, SolveSpace, KiCad, Cura, PrusaSlicer)";

    config = lib.mkIf config.apps.cad.enable {
      environment.systemPackages = with pkgs; [
        freecad
        openscad
        solvespace
        kicad
        cura-appimage
        prusa-slicer
      ];
    };
  };
}
