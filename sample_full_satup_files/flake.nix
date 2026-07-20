{
  description = "PrameKung's Lenovo Legion NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # This profile is only appropriate for the Lenovo Legion 5 15ARH05H.
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }: {
    nixosConfigurations.pramekung_legion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-hardware.nixosModules.lenovo-legion-15arh05h
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.pramekung = import ./home.nix;
          };
        }
      ];
    };
  };
}
