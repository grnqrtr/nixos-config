{ config, lib, pkgs, ... }:

{
  #### Add a systemd service to reload the psmouse kernel driver after suspend/resume
  systemd.services."reset-psmouse" = {
    description = "Reset ThinkPad touchpad/trackpoint after suspend (reloads psmouse)";
    wantedBy = [ "suspend.target" ];
    after = [ "suspend.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe -r psmouse";
      ExecStartPost = "${pkgs.kmod}/bin/modprobe psmouse";
    };
  };
}
