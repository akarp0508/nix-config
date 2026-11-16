{ ... }: {
  flake.nixosModules.appsDev = { config, lib, pkgs, ... }: {
    options.apps.dev.enable = lib.mkEnableOption "development tools (zed-editor, claude-code, gh, home-manager, IntelliJ IDEA + Java toolchain, Android Studio, Wine, Python, language servers, adb, direnv, Docker)";

    config = lib.mkIf config.apps.dev.enable {
      environment.systemPackages = with pkgs; [
        zed-editor
        claude-code
        gh
        home-manager

        # Java (25: matches what javaCAD and IntelliJ expect)
        jetbrains.idea
        jdk25
        maven
        gradle

        # Bundles its own JBR and downloads the Android SDK on first run (to ~/Android/Sdk).
        android-studio
        # adb/fastboot: install builds on the phone, read logcat. No adb group
        # needed: systemd's uaccess grants the logged-in user USB access.
        android-tools

        # Run Windows .exe tools. wow64 (not wineWowPackages) is the variant
        # prebuilt in cache.nixos.org; the other one compiles Wine from source.
        wineWow64Packages.stable

        # Python. NixOS's python3 is immutable (no system-wide pip install),
        # so uv is the escape hatch for per-project venvs/dependencies.
        python3
        uv

        # Language servers for Claude Code's LSP plugins (jdtls-lsp, clangd-lsp,
        # pyright-lsp). The plugins only call these binaries from PATH.
        jdt-language-server
        clang-tools
        pyright

        # Microcontroller firmware (koiclock etc.). The FHS wrapper is needed
        # because PlatformIO downloads prebuilt toolchains at runtime. Serial
        # access to boards comes from the dialout group (see host configuration.nix).
        platformio
        # Native unit tests for firmware logic (pio test -e native).
        gcc
        # WebAssembly builds (koiclock's LED core runs in the browser). The
        # unwrapped clang is needed: nixpkgs' clang wrapper adds host libc flags.
        llvmPackages.clang-unwrapped
        llvmPackages.lld

        jq
      ];

      # Per-project toolchains: a project's .envrc (`use flake`) loads its
      # devShell on cd. nix-direnv (on by default) caches it and keeps it
      # from being garbage-collected. Hooks into zsh automatically.
      programs.direnv.enable = true;

      # Docker daemon; the user is in the docker group (see host configuration.nix).
      virtualisation.docker.enable = true;

      # nixpkgs' maven/gradle bake in their own JDK dependency internally and
      # ignore PATH, so without this they'd silently use a different JDK than
      # the one above regardless of what's first on PATH.
      environment.variables.JAVA_HOME = "${pkgs.jdk25}";
    };
  };
}
