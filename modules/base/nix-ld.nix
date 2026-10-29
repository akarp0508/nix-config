{ ... }: {
  # Lets precompiled, non-Nix-packaged binaries (random downloaded tools,
  # native libs pulled in transitively like JavaFX's graphics engine) find
  # their shared libraries at runtime, instead of needing a per-project
  # devShell every time something hits a missing .so.
  flake.nixosModules.nixLd = { pkgs, lib, ... }:
  let
    # Shared by both mechanisms below: nix-ld's own stub-interpreter trick
    # only rewrites foreign *executables* at exec() time. A Nix-native
    # process (e.g. the JVM) dlopen()-ing a foreign .so at runtime - like
    # JavaFX's bundled native graphics/GTK loaders - never goes through
    # exec(), so it only ever sees plain LD_LIBRARY_PATH.
    commonLibraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      fontconfig
      freetype
      glib
      gtk3
      libxxf86vm
      libxtst
      libglvnd
    ];
  in
  {
    programs.nix-ld = {
      enable = true;
      libraries = commonLibraries;
    };

    # GL dispatch (libglvnd, above) needs the actual vendor driver (NVIDIA
    # here, via /run/opengl-driver) to hit real hardware acceleration
    # instead of falling back to software rendering.
    environment.variables.LD_LIBRARY_PATH = [
      (lib.makeLibraryPath commonLibraries)
      "/run/opengl-driver/lib"
    ];
  };
}
