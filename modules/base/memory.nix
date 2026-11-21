{ ... }: {
  flake.nixosModules.memory = { ... }: {
    # Compressed swap in RAM, used before the NVMe swap partition (higher
    # priority by default). Defaults: zstd, 50% of RAM as the uncompressed limit.
    zramSwap.enable = true;

    # Kills the biggest process when both RAM and swap run low, before the
    # system thrashes into a freeze (the kernel OOM killer reacts far too late).
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 5;  # percent
      freeSwapThreshold = 10;
      enableNotifications = true;
      # Never sacrifice the compositor or init to save a browser tab.
      extraArgs = [ "--avoid" "(^|/)(niri|systemd|Xwayland)$" ];
    };
  };
}
