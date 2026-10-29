{ self, ... }: {
  # Hardware/display-independent basics every host of mine wants, bundled
  # so hosts don't have to list each one individually.
  flake.nixosModules.base = { ... }: {
    imports = [
      self.nixosModules.zsh
      self.nixosModules.audio
      self.nixosModules.printing
      self.nixosModules.nixSettings
      self.nixosModules.locale
      self.nixosModules.bootloader
      self.nixosModules.networkmanager
      self.nixosModules.nixLd
    ];
  };
}
