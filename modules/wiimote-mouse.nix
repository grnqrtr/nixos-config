{ pkgs, ... }:

{
  # Allow xwiimote-mouse to create a virtual mouse via uinput.
  boot.kernelModules = [ "uinput" ];
  services.udev.packages = [ pkgs.xwiimote ];
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
  '';
}
