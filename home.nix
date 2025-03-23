{ config, pkgs, stablePkgs, inputs, ... }:

let

in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "grnqrtr";
  home.homeDirectory = "/home/grnqrtr";

  # Import other modules
  imports = [
    ./hm-modules/librewolf.nix
    ./hm-modules/flatpak.nix
    ./hm-modules/shell/zsh.nix
    ./hm-modules/gaming/perfectdark.nix
    ./hm-modules/gaming/sm64coopdx.nix
    ./hm-modules/gaming/pico8.nix
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
    targets.librewolf.profileNames = [ "Default" ];
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
    gamescope # For splitscreen
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

  };

  programs.vscode = {
    enable = true;
    profiles.default.userSettings = { "platformio-ide.useBuiltinPIOCore" = false; };
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
