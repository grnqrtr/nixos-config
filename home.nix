{ config, pkgs, stablePkgs, inputs, ... }:

let
  myAliases = {
    cb = "xclip -selection c";
    ll = "ls -l";
    la = "ls -la";
    ".." = "cd ..";
    config = "cd /home/grnqrtr/.nixos-config";
    flake-update = "nix flake update /home/grnqrtr/.nixos-config/";
    home-switch = "home-manager switch --flake /home/grnqrtr/.nixos-config/";
    nix-rebuild = "sudo nixos-rebuild switch --flake /home/grnqrtr/.nixos-config/#t480s";
    home-edit = "nano /home/grnqrtr/.nixos-config/home.nix";
    nix-edit = "nano /home/grnqrtr/.nixos-config/machines/t480s/configuration.nix";
    flake-edit = "nano /home/grnqrtr/.nixos-config/flake.nix";
  };
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "grnqrtr";
  home.homeDirectory = "/home/grnqrtr";

  programs.git = {
    enable = true;
    userName = "grnqrtr";
    userEmail = "grnqrtr@protonmail.com";
    extraConfig = {
      init.defaultBranch = "master";
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    #
    # Add stable package like this: stablePkgs.neovim
    xclip
    gimp-with-plugins
    audacity
    yt-dlp
    meld

    # Communications
    discord
    telegram-desktop
    zoom-us
    skypeforlinux

    # Games
    shipwright
    wargus
    (prismlauncher.override { jdks = [ pkgs.temurin-bin-21 ]; }) # Minecraft launcher
#    sm64ex
#    sm64ex-coop

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
    oh-my-zsh = {
      enable = true;
      theme = "bira";
    };
  };

  programs.vscode = {
    enable = true;
    userSettings = { "platformio-ide.useBuiltinPIOCore" = false; };
  };

  programs.sm64ex = {
    enable = true;
    settings = {
      fullscreen = true;
      extraCompileFlags = [
        "BETTERCAMERA=1"
        "NODRAWINGDISTANCE=1"
        "EXT_OPTIONS_MENU=1"
        "TEXTURE_FIX=1"
      ];
    };
  };

  xdg = {
    enable = true;
    desktopEntries = {
      pico-8 = {
        name = "Pico-8";
        exec = "${pkgs.bash}/bin/bash -c \"nix-shell ${config.home.homeDirectory}/.nixos-config/nix-shells/pico8.nix\"";
        icon = "${config.home.homeDirectory}/Apps/pico-8/lexaloffle-pico8.png";
        type = "Application";
        categories = [ "X-Programming" "Game" ];
        comment = "PICO-8 Fantasy Console";
        terminal = false;
      };
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/grnqrtr/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
