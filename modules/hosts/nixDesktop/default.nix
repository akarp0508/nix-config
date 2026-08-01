{ self, inputs, ... }: {

  flake.nixosConfiguration.nixDesktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopConfiguration
    ];
  };

}
