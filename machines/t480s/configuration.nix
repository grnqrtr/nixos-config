# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/jp-input-ibus.nix # Japanese Input. Pick jp-input-ibus.nix or jp-input-fcitx5.nix
      ../../modules/canon-TS8330.nix
      ../../modules/xbox-controller.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-87785bc8-18ed-4345-8710-3d0a7d124225".device = "/dev/disk/by-uuid/87785bc8-18ed-4345-8710-3d0a7d124225";
  networking.hostName = "t480s"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;
  ## To check for and install firmware updates:
  ## sudo fwupdmgr refresh
  ## sudo fwupdmgr get-updates
  ## sudo fwupdmgr update 

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; # To fix build error - "Failed to start Network Manager Wait Online."

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  services.udev.packages = [ pkgs.sane-airscan ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Setup fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      migu
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      zpix-pixel-font

      montserrat
      nerd-fonts.jetbrains-mono
      font-awesome
      symbola
      material-icons

    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.displayManager.autoLogin.user = "grnqrtr";
  services.xserver.desktopManager.gnome.enable = true;

  # Enable COSMIC
#  services.desktopManager.cosmic.enable = true;
#  services.displayManager.cosmic-greeter.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS and other printer settings.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ cnijfilter2 ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.grnqrtr = {
    isNormalUser = true;
    description = "Travis";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" "scanner" "lp" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Register zsh as an available shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget

  # Common tools
  docker-compose
  appimage-run
  tree
  zip
  unzip
  git
  wget
  curl
  kitty
  certbot

  # Gnome
  gnome-tweaks
  gnomeExtensions.dash-to-dock
  gnomeExtensions.thinkpad-battery-threshold
  gnomeExtensions.pop-shell
  gnomeExtensions.appindicator
  gnomeExtensions.rounded-window-corners-reborn
  gnomeExtensions.open-bar
  pop-icon-theme

  # Trezor & pass
  trezor_agent
  (pass.withExtensions (ext: with ext; [ pass-otp pass-genphrase pass-update ]))
  (python311.withPackages(ps: with ps; [ base58 pyserial unidecode ]))
  wl-clipboard  # Needed for pass

  ];

  # Set environment variables here
  environment.variables = {
    GNUPGHOME = "$HOME/.gnupg/trezor";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable Tailscale client daemon
  services.tailscale.enable = true;

  # Enable Trezor bridge daemon and setup udev rules 
  services.trezord.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable AppImages
  programs.appimage.binfmt.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ]; # Enable this to build arm docker contatin.

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable KDE connect
  programs.kdeconnect.enable = true;
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

  # Enable Tor
  services.tor.enable = true;
  services.tor.client.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
