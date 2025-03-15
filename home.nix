{ config, pkgs, stablePkgs, inputs, ... }:

let
  myAliases = {
    cb = "xclip -selection c";
    ll = "ls -l";
    la = "ls -la";
    ".." = "cd ..";
    config = "cd /home/grnqrtr/.nixos-config";
    flake-update = "nix flake update --flake /home/grnqrtr/.nixos-config/";
    home-switch = "home-manager switch --flake /home/grnqrtr/.nixos-config/";
    nix-rebuild = "sudo nixos-rebuild switch --flake /home/grnqrtr/.nixos-config/#t480s";
    home-edit = "nano /home/grnqrtr/.nixos-config/home.nix";
    nix-edit = "nano /home/grnqrtr/.nixos-config/machines/t480s/configuration.nix";
    flake-edit = "nano /home/grnqrtr/.nixos-config/flake.nix";
    cg = "sudo nix-collect-garbage && sudo nix-collect-garbage -d && nix-collect-garbage && nix-collect-garbage -d";
  };

  # Define sm64coopdx 2-player script
  sm64coopdx-2p = pkgs.writeScriptBin "sm64coopdx-2p" ''
    #!/usr/bin/env bash
    mkdir -p ~/.local/share/sm64coopdx_second_player
    bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx_second_player ~/.local/share/sm64coopdx sm64coopdx & sm64coopdx
  '';

  # Define sm64coopdx 4-player script
  sm64coopdx-4p = pkgs.writeScriptBin "sm64coopdx-4p" ''
    #!/usr/bin/env bash
    mkdir -p ~/.local/share/sm64coopdx_second_player
    mkdir -p ~/.local/share/sm64coopdx_third_player
    mkdir -p ~/.local/share/sm64coopdx_fourth_player
    bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx_second_player ~/.local/share/sm64coopdx sm64coopdx & \
    bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx_third_player ~/.local/share/sm64coopdx sm64coopdx & \
    bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx_fourth_player ~/.local/share/sm64coopdx sm64coopdx & sm64coopdx
  '';

in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "grnqrtr";
  home.homeDirectory = "/home/grnqrtr";

  # Import other modules
  imports = [
    ./hm-modules/gaming/perfectdark.nix
    ./hm-modules/librewolf.nix
  ];

  programs.git = {
    enable = true;
    userName = "grnqrtr";
    userEmail = "grnqrtr@protonmail.com";
    extraConfig = {
      init.defaultBranch = "master";
    };
  };

  # Styling Options
  stylix = {
    enable = true;
    image = ./moon-wallpaper.jpg;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    targets.vscode.profileNames = [ "default" ];
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Workaround to set active hint color
  dconf.settings."org/gnome/shell/extensions/pop-shell" = {
    hint-color-rgba = "rgba(0, 255, 255, 1)";
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
    
    # Tools
    xclip
    meld
    filezilla
    temurin-jre-bin
    chromium
    inkscape
    bottles
    anki

    # Audio/Video
    vlc
    audacious
    audacity
    yt-dlp
    ffmpeg

    # Ebooks
    sigil
    calibre

    # Communications
    discord
    telegram-desktop
    signal-desktop
    zoom-us
    skypeforlinux

    # Games
    shipwright
    _2ship2harkinian
    wargus
    (prismlauncher.override { jdks = [ pkgs.temurin-bin-21 ]; }) # Minecraft launcher
    sm64coopdx
    sm64coopdx-2p
    sm64coopdx-4p
    gamescope # For splitscreen
    bubblewrap # For splitscreen
    sidequest
    minetest
    lutris
    protonup-qt

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

    # Super Mario Coop DX Icon
    ".config/icons/sm64ex-coop.png".source = builtins.fetchurl {
      url = "https://cdn2.steamgriddb.com/icon/335656f07e73e44e19221e6649796c54/32/256x256.png";
      sha256 = "d3dd82928fbc2873e7fce2db5e0470ff618f3575ad3259272c1ae5f934034a59";
    };
  };

  services.flatpak = {
    enable = true;
    packages = [
      "org.gimp.GIMP//stable"
      "org.gimp.GIMP.Plugin.Resynthesizer//2-40"
    ];
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
    profiles.default.userSettings = { "platformio-ide.useBuiltinPIOCore" = false; };
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
      sm64coopdx = {
        name = "SM64 Coop DX";
        exec = "sm64coopdx-2p";
        icon = "${config.home.homeDirectory}/.config/icons/sm64ex-coop.png";
        type = "Application";
        categories = [ "Game" "X-Port" ];
        comment = "N64 Port";
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
