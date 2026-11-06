{ ... }: {
  flake.nixosModules.appsCad = { config, lib, pkgs, ... }:
  let
    # Not in nixpkgs; upstream only ships binaries, so wrap the release AppImage.
    solidcraft = pkgs.appimageTools.wrapType2 {
      pname = "solidcraft";
      version = "0.30.1";
      src = pkgs.fetchurl {
        url = "https://github.com/tangency-labs/solidcraft/releases/download/v0.30.1/solidcraft-0.30.1-linux-x86_64.AppImage";
        hash = "sha256-HODWGv04IA8MFieTGgSF8DuD4KiLHHTHXhoVAek4g10=";
      };
    };
  in {
    options.apps.cad.enable = lib.mkEnableOption "CAD / 3D-printing tools (FreeCAD, OpenSCAD, SolveSpace, KiCad, SolidCraft, Cura, PrusaSlicer)";

    config = lib.mkIf config.apps.cad.enable {
      environment.systemPackages = with pkgs; [
        freecad
        openscad
        solvespace
        kicad
        cura-appimage
        prusa-slicer
        solidcraft
      ];
    };
  };
}
