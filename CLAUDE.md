# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- Apply config (user runs this, never Claude): `sudo nixos-rebuild switch --flake .#nixDesktop` (alias `renix`).
- Check without applying: `nix flake check` or `nix eval .#nixosConfigurations.nixDesktop.config.system.build.toplevel.drvPath`.
- Build without activating (no sudo): `nix build .#nixosConfigurations.nixDesktop.config.system.build.toplevel --no-link`.
- There are no tests or linters. Single host: `nixDesktop`, `x86_64-linux`.

## Architecture

Dendritic pattern: `flake.nix` passes `inputs.import-tree ./modules` to flake-parts `mkFlake`, so **every `.nix` file under `modules/` is auto-imported as a flake-parts module**. There is no import list; a new file is wired in just by existing (git-track it, since flakes ignore untracked files).

Each file defines one or more `flake.nixosModules.<name>` (a NixOS module nested inside the flake-parts module). Modules reference each other through `self.nixosModules.<name>`, not file paths.

- `modules/base/`: host-independent basics, bundled by `base.nix` as `nixosModules.base`. A new base module must also be added to the imports list in `base.nix`.
- `modules/features/`: opt-in pieces (niri, noctalia, nvidia, kitty, syncthing, sunshine, theming, monitors). Hosts import the ones they need. niri and noctalia packages are built with `nix-wrapper-modules` from declarative settings.
- `modules/apps/`: package groups, each exposing an `apps.<name>.enable` option (`core`, `dev`, `browsers`, `gaming`, `social`, `desktop`, `cad`). Add packages to the matching module; update the `mkEnableOption` description when the contents change.
- `modules/hosts/nixDesktop/`: `default.nix` defines `nixosConfigurations.nixDesktop` from `nixosModules.desktopConfiguration` (`configuration.nix`), which imports base/features/apps and sets `apps.*.enable = true`. Also holds hardware config and monitor layout.

To enable a new module on the host: define it, add `self.nixosModules.<name>` to the imports in `configuration.nix`, and enable its option if it has one.

## Conventions

- Comment the *why* for non-obvious package choices (e.g. `wineWow64Packages` is used because it is prebuilt in cache.nixos.org; the other variant compiles Wine).
- Avoid anything that triggers large source builds; check the package is cached.
