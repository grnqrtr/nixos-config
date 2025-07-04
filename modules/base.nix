{ config, pkgs, ... }:

{

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  #time.timeZone = "Asia/Tokyo";
  #time.timeZone = "America/Los_Angeles";
  time.timeZone = "America/Anchorage";

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

  # Services

  # Enable Tailscale client daemon
  services.tailscale.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Enable AppImages
  programs.appimage.binfmt.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv7l-linux" ]; # Enable this to build arm docker contatin.

}
