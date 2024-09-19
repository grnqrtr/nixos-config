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

  overlays = import ./overlays.nix;
  pkgsWithOverlays = pkgs.extend (self: super: overlays self super);

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
  home.packages = with pkgsWithOverlays; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    #
    # Add stable package like this: stablePkgs.neovim
    
    # Tools
    xclip
    audacity
    yt-dlp
    meld
    sigil
    calibre

    # Communications
    discord
    telegram-desktop
    zoom-us
    skypeforlinux

    # Games
    shipwright
    _2ship2harkinian
    wargus
    (prismlauncher.override { jdks = [ pkgs.temurin-bin-21 ]; }) # Minecraft launcher
    sm64ex
    sm64ex-coop-renamed # Renamed binary with overlay to avoid collision with sm64ex
    sidequest

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

    # Perfect Dark Icon
    ".config/icons/pd.png".source = builtins.fetchurl {
      url = "https://cdn2.steamgriddb.com/icon/64314c17210c549a854f1f1c7adce8b6/32/256x256.png";
      sha256 = "111e4e08510dcab77b47860208723f525769530ebfcd08c7ed09e224e9c41ff1";
    };

    # Super Mario Ex Icon
    ".config/icons/sm64ex.png".source = builtins.fetchurl {
      url = "https://cdn2.steamgriddb.com/icon/801272ee79cfde7fa5960571fee36b9b/32/256x256.png";
      sha256 = "21983cba2ef47f0039103276f83154da166c1d575a2da185041f5e018be0b9f5";
    };
    # Super Mario Ex-Coop Icon
    ".config/icons/sm64ex-coop.png".source = builtins.fetchurl {
      url = "https://cdn2.steamgriddb.com/icon/335656f07e73e44e19221e6649796c54/32/256x256.png";
      sha256 = "d3dd82928fbc2873e7fce2db5e0470ff618f3575ad3259272c1ae5f934034a59";
    };
  };

  services.flatpak = {
    enableModule = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    packages = [
      "flathub:app/org.gimp.GIMP//stable"
      "flathub:runtime/org.gimp.GIMP.Plugin.Resynthesizer//2-40"
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
    userSettings = { "platformio-ide.useBuiltinPIOCore" = false; };
  };

  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = with builtins;
        let extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
        in listToAttrs [
          (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "10ten-ja-reader" "{59812185-ea92-4cca-8ab7-cfcacee81281}")
          (extension "absolute-enable-right-click" "{9350bc42-47fb-4598-ae0f-825e3dd9ceba}")
          (extension "multi-account-containers" "@testpilot-containers")
          (extension "traduzir-paginas-web" "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}") # TWP - Translate Web Pages
          (extension "windscribe" "@windscribeff")
        ];
        # To add additional extensions, find it on addons.mozilla.org, find
        # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
        # Then, download the XPI by filling it in to the install_url template, unzip it,
        # run `jq .browser_specific_settings.gecko.id manifest.json` or
        # `jq .applications.gecko.id manifest.json` to get the UUID
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
      perfectdark = {
        name = "Perfect Dark";
        exec = "steam-run ${config.home.homeDirectory}/Apps/Roms/PerfectDark/pd";
        icon = "${config.home.homeDirectory}/.config/icons/pd.png";
        type = "Application";
        categories = [ "Game" "X-Port" ];
        comment = "N64 Port";
        terminal = false;
      };
      sm64ex = {
        name = "SM64 EX";
        exec = "sm64ex";
        icon = "${config.home.homeDirectory}/.config/icons/sm64ex.png";
        type = "Application";
        categories = [ "Game" "X-Port" ];
        comment = "N64 Port";
        terminal = false;
      };
      sm64ex-coop = {
        name = "SM64 EX Coop";
        exec = "sm64ex-coop";
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
