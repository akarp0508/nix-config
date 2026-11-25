{ ... }: {
  flake.nixosModules.bluetooth = { ... }: {
    # BlueZ daemon; the kernel already drives the USB dongle (btusb).
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
