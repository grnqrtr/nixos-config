{ config, pkgs, ... }:

{

  home.packages = with pkgs; [ xclip ]; # For cb alias

  programs.zsh = {
    enable = true;

    # Define shell aliases
    shellAliases = {
      cb = "xclip -selection c";
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      config = "cd /home/grnqrtr/.nixos-config";
      flake-update = "nix flake update --flake /home/grnqrtr/.nixos-config/";
      home-switch = "home-manager switch --flake /home/grnqrtr/.nixos-config/#grnqrtr";
      nix-rebuild = "sudo nixos-rebuild switch --flake /home/grnqrtr/.nixos-config/#t480s";
      home-edit = "nano /home/grnqrtr/.nixos-config/homes/grnqrtr/home.nix";
      nix-edit = "nano /home/grnqrtr/.nixos-config/machines/t480s/configuration.nix";
      flake-edit = "nano /home/grnqrtr/.nixos-config/flake.nix";
      cg = "sudo nix-collect-garbage -d && nix-collect-garbage -d && nix-store --optimise";
    };

    # Enable oh-my-zsh with theme
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };
  };
}
