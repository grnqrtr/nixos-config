{ config, pkgs, ... }:

let
  # Bind homeDir locally to avoid recursion issues.
  homeDir = config.home.homeDirectory;
  # Base directory holding Pico-8's binary and icon.
  pico8Dir = "${homeDir}/Apps/pico-8";

  # Build the Pico-8 FHS environment using buildFHSEnv.
  pico8Shell = pkgs.buildFHSEnv {
    name = "pico8-shell";
    targetPkgs = pkgs: [
      pkgs.xorg.libX11
      pkgs.xorg.libXext
      pkgs.xorg.libXcursor
      pkgs.xorg.libXinerama
      pkgs.xorg.libXi
      pkgs.xorg.libXrandr
      pkgs.xorg.libXScrnSaver
      pkgs.xorg.libXxf86vm
      pkgs.xorg.libxcb
      pkgs.xorg.libXrender
      pkgs.xorg.libXfixes
      pkgs.xorg.libXau
      pkgs.xorg.libXdmcp
      pkgs.alsa-lib
      pkgs.udev
    ];
    # Use pico8Dir for the binary location.
    runScript = "bash -c '${pico8Dir}/pico8'";
  };
in {
  # Contribute the pico8Shell derivation directly to home.packages.
  home.packages = [ pico8Shell ];

  # Create an XDG desktop entry for Pico-8. Both the icon and the shell rely on pico8Dir.
  xdg.desktopEntries = {
    pico8 = {
      name = "Pico-8";
      exec = "pico8-shell";
      icon = "${pico8Dir}/lexaloffle-pico8.png";
      type = "Application";
      categories = [ "X-Programming" "Game" ];
      comment = "PICO-8 Fantasy Console";
      terminal = false;
    };
  };
}
