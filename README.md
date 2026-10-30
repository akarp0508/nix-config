# nix-config

Personal NixOS configuration using the [dendritic pattern](https://github.com/mightyiam/dendritic):
every `.nix` file under `modules/` is a self-contained flake-parts module,
auto-imported via [`import-tree`](https://github.com/vic/import-tree) (see
`flake.nix`). There's no central list of imports to maintain — dropping a
new file into `modules/` is enough to wire it in.

## Layout

- `modules/base/` — host-independent basics every machine wants (shell,
  audio, locale, bootloader, networking, nix settings). Bundled together
  as `nixosModules.base`.
- `modules/features/` — opt-in, more opinionated pieces (niri, noctalia
  shell/greeter, monitors, nvidia, syncthing, kitty). Hosts import the
  ones they need.
- `modules/apps/` — package groups behind an `apps.<name>.enable` option
  (dev tools, browsers, gaming, social, desktop, CAD).
- `modules/hosts/<name>/` — one directory per machine, wiring together
  `base` + whichever `features`/`apps` that host wants, plus its
  hardware-configuration.nix and the `nixosConfigurations.<name>` output.

Currently one host: `nixDesktop` (niri + noctalia, NVIDIA, triple monitor).

## Usage

```sh
sudo nixos-rebuild switch --flake /home/akarp0508/.nixos-dendritic
```

Aliased as `renix` in the zsh config (`modules/base/zsh.nix`).

## Notable dependencies

- [`flake-parts`](https://github.com/hercules-ci/flake-parts) — the module
  system this whole setup is built on.
- [`nix-wrapper-modules`](https://github.com/BirdeeHub/nix-wrapper-modules) —
  used to build the niri and noctalia-shell packages from declarative
  settings (see `modules/features/niri.nix`, `modules/features/noctalia.nix`).
