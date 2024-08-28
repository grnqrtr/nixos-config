{
  description = "main flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stableNixpkgs.url = "github:NixOS/nixpkgs/release-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = { self, nixpkgs, stableNixpkgs, home-manager, nixos-hardware, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    stablePkgs = import stableNixpkgs { inherit system; };
  in
  {
    
    nixosConfigurations = {
      t480s = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; };
        modules = [ 
          ./machines/t480s/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t480s
        ];
      };
    };

    homeConfigurations = {
      grnqrtr = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit stablePkgs inputs; };
        modules = [ ./home.nix ];
      };
    };
  };
}
