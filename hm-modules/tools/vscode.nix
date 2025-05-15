{ config, pkgs, ... }:

{

  home.packages = with pkgs; [
  python3
  zsh
  ];

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        ms-vscode-remote.remote-containers
      ];
      userSettings = {
        python.defaultInterpreterPath = "${pkgs.python3}/bin/python";
        terminal.integrated.shell.linux = "${pkgs.zsh}/bin/zsh";
      };
    };
  };
}
