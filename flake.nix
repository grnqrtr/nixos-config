{
  description = "main flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stableNixpkgs.url = "github:NixOS/nixpkgs/release-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    firefox-csshacks = { 
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, stableNixpkgs, home-manager, stylix, nixos-cosmic, nixos-hardware, nix-flatpak, firefox-csshacks, ... }@inputs:
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
          nix-flatpak.homeManagerModules.nix-flatpak
          stylix.homeManagerModules.stylix
          ./users/grnqrtr/home.nix
        ];
      };
    };
  };
}
