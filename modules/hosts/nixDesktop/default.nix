{ self, inputs, ... }: {

  flake.nixosConfigurations.nixDesktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktopConfiguration
    ];
  };

}
