{ ... }: {
  flake.nixosModules.appsCad = { config, lib, pkgs, ... }: {
    options.apps.cad.enable = lib.mkEnableOption "CAD / 3D-printing tools (FreeCAD, OpenSCAD, Cura, PrusaSlicer)";

    config = lib.mkIf config.apps.cad.enable {
      environment.systemPackages = with pkgs; [
        freecad
        openscad
        cura-appimage
        prusa-slicer
      ];
    };
  };
}
