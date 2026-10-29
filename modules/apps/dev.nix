{ ... }: {
  # Development tooling.
  flake.nixosModules.appsDev = { config, lib, pkgs, ... }: {
    options.apps.dev.enable = lib.mkEnableOption "development tools (zed-editor, claude-code, home-manager, IntelliJ IDEA + Java toolchain)";

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
      ];

      # nixpkgs' maven/gradle bake in their own JDK dependency internally and
      # ignore PATH, so without this they'd silently use a different JDK than
      # the one above regardless of what's first on PATH.
      environment.variables.JAVA_HOME = "${pkgs.jdk25}";
    };
  };
}
