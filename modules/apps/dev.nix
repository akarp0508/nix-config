{ ... }: {
  # Development tooling.
  flake.nixosModules.appsDev = { config, lib, pkgs, ... }: {
    options.apps.dev.enable = lib.mkEnableOption "development tools (zed-editor, claude-code, home-manager, IntelliJ IDEA + Java toolchain, Python)";

    config = lib.mkIf config.apps.dev.enable {
      environment.systemPackages = with pkgs; [
        zed-editor
        claude-code
        home-manager

        # Java (25: matches what javaCAD and IntelliJ expect)
        jetbrains.idea
        jdk25
        maven
        gradle

        # Python. NixOS's python3 is immutable (no system-wide pip install),
        # so uv is the escape hatch for per-project venvs/dependencies.
        python3
        uv
      ];

      # nixpkgs' maven/gradle bake in their own JDK dependency internally and
      # ignore PATH, so without this they'd silently use a different JDK than
      # the one above regardless of what's first on PATH.
      environment.variables.JAVA_HOME = "${pkgs.jdk25}";
    };
  };
}
