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
      config = "cd /home/kids/.nixos-config";
      flake-update = "nix flake update --flake /home/kids/.nixos-config/";
      home-switch = "home-manager switch --flake /home/kids/.nixos-config/#kids";
      nix-rebuild = "sudo nixos-rebuild switch --flake /home/kids/.nixos-config/#x270";
      home-edit = "nano /home/kids/.nixos-config/homes/kids/home.nix";
      nix-edit = "nano /home/kids/.nixos-config/machines/x270/configuration.nix";
      flake-edit = "nano /home/kids/.nixos-config/flake.nix";
      cg = "sudo nix-collect-garbage -d && nix-collect-garbage -d && nix-store --optimise";
      refresh = "sudo rm -rf /home/kids/.nixos-config && git clone https://github.com/grnqrtr/nixos-config /home/kids/.nixos-config"
    };

    # Enable oh-my-zsh with theme
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };
  };
}
