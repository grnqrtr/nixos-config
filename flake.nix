{
  description = "main flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stableNixpkgs.url = "github:NixOS/nixpkgs/release-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    flatpaks.url = "github:GermanBread/declarative-flatpak/stable-v3";
    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = { self, nixpkgs, stableNixpkgs, home-manager, stylix, nixos-cosmic, nixos-hardware, flatpaks, ... }@inputs:
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
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./machines/t480s/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-t480s
        ];
      };
    };

    homeConfigurations = {
      grnqrtr = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit stablePkgs inputs; };
        modules = [
          flatpaks.homeManagerModules.declarative-flatpak
          stylix.homeManagerModules.stylix
          ./home.nix
        ];
      };
    };
  };
}
