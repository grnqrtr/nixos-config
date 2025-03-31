{ config, pkgs, ... }:

{

  # Enable CUPS and other printer settings.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ cnijfilter2 ];

  # Scanning setup
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];
  services.udev.packages = [ pkgs.sane-airscan ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

}
