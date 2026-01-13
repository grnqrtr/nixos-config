# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ ./hardware-configuration.nix # Include the results of the hardware scan.
      ../../modules/base.nix
      ../../modules/jp-input-ibus.nix # Japanese Input. Pick jp-input-ibus.nix or jp-input-fcitx5.nix
      ../../modules/canon-TS8330.nix
      ../../modules/xbox-controller.nix
      ../../modules/reset-psmouse.nix
      ../../modules/wiimote-mouse.nix
    ];

  boot.initrd.luks.devices."luks-87785bc8-18ed-4345-8710-3d0a7d124225".device = "/dev/disk/by-uuid/87785bc8-18ed-4345-8710-3d0a7d124225";
  networking.hostName = "t480s"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;
  ## To check for and install firmware updates:
  ## sudo fwupdmgr refresh
  ## sudo fwupdmgr get-updates
  ## sudo fwupdmgr update 

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false; # To fix build error - "Failed to start Network Manager Wait Online."

  # Setup fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      migu
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      zpix-pixel-font

      helvetica-neue-lt-std

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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Disable tracker (file search) because of error.
  services.gnome.tinysparql.enable = false;
  services.gnome.localsearch.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" "scanner" "lp" "input" ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "grnqrtr";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Register zsh as an available shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

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
  gnomeExtensions.hide-top-bar
  pop-icon-theme

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable Trezor bridge daemon and setup udev rules 
  services.trezord.enable = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Enable Syncthing
  services.syncthing = {
    enable = true;
    user = "grnqrtr";
    dataDir = "/home/grnqrtr/Sync";    # Default folder for new synced folders
    configDir = "/home/grnqrtr/.config/syncthing";   # Folder for Syncthing's settings and keys
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
