{ ... }: {
  # systemd-boot on UEFI. Reusable for any UEFI host.
  flake.nixosModules.bootloader = { ... }: {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
