{ pkgs, ... }:

let
  sindenLibs = with pkgs; [
    SDL
    SDL_image
    libjpeg8
    libv4l
    v4l-utils
  ];
  sindenLdPath = pkgs.lib.makeLibraryPath sindenLibs;
in
{
  # Runtime dependencies for LightgunMono.exe on Linux.
  environment.systemPackages =
    sindenLibs
    ++ [
      pkgs.mono
      pkgs.dotnet-runtime
      pkgs.usbutils
      pkgs.psmisc
      pkgs.lsof
      pkgs.strace
      (pkgs.writeShellScriptBin "sinden-lightgun" ''
        exe="''${1:-./LightgunMono.exe}"
        if [ ! -f "$exe" ]; then
          echo "sinden-lightgun: LightgunMono.exe not found: $exe" >&2
          echo "Usage: sinden-lightgun [/path/to/LightgunMono.exe] [args...]" >&2
          exit 1
        fi
        exe_dir="$(cd "$(dirname "$exe")" && pwd)"
        export LD_LIBRARY_PATH="''${exe_dir}:${sindenLdPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
        exec ${pkgs.mono}/bin/mono "$exe" "''${@:2}"
      '')
    ];

  # Allow the driver to create a virtual mouse/joystick via uinput.
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    # Keep ModemManager away from the Sinden serial interface and avoid USB autosuspend.
    SUBSYSTEM=="tty", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="0f39", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
    SUBSYSTEM=="usb", ATTR{idVendor}=="16c0", ATTR{idProduct}=="0f39", ATTR{power/control}="on"
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="1098", ATTR{power/control}="on"
  '';

  # Make non-Nix binaries (like LightgunMono.exe) find their shared libs.
  programs.nix-ld = {
    enable = true;
    libraries = sindenLibs;
  };
}
