{ config, pkgs, ... }:

{
  # Download the SM64 Co-Op DX icon.
  home.file = {
    ".config/icons/sm64ex-coop.png".source = builtins.fetchurl {
      url = "https://cdn2.steamgriddb.com/icon/335656f07e73e44e19221e6649796c54/32/256x256.png";
      sha256 = "d3dd82928fbc2873e7fce2db5e0470ff618f3575ad3259272c1ae5f934034a59";
    };
  };

  # Add the SM64 Coop DX package and script binaries.
  home.packages = with pkgs; [
    bubblewrap # This provides the "bwrap" command to bind extra player folders.
    sm64coopdx
    (pkgs.writeScriptBin "sm64coopdx-2p" ''
      #!/usr/bin/env bash
      mkdir -p ~/.local/share/sm64coopdx-2p
      bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx-2p ~/.local/share/sm64coopdx sm64coopdx & sm64coopdx
    '')
    (pkgs.writeScriptBin "sm64coopdx-3p" ''
      #!/usr/bin/env bash
      mkdir -p ~/.local/share/sm64coopdx-2p
      mkdir -p ~/.local/share/sm64coopdx-3p
      bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx-2p ~/.local/share/sm64coopdx sm64coopdx & \
      bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx-3p ~/.local/share/sm64coopdx sm64coopdx & sm64coopdx
    '')
    (pkgs.writeScriptBin "sm64coopdx-4p" ''
      #!/usr/bin/env bash
      mkdir -p ~/.local/share/sm64coopdx-2p
      mkdir -p ~/.local/share/sm64coopdx-3p
      mkdir -p ~/.local/share/sm64coopdx-4p
      bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx-2p ~/.local/share/sm64coopdx sm64coopdx & \
      bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx-3p ~/.local/share/sm64coopdx sm64coopdx & \
      bwrap --dev-bind / / --bind ~/.local/share/sm64coopdx-4p ~/.local/share/sm64coopdx sm64coopdx & sm64coopdx
    '')
  ];

  # Define the XDG desktop entry for SM64 Coop DX.
  xdg.desktopEntries = {
    sm64coopdx = {
      name = "SM64 Co-Op DX";
      exec = "sm64coopdx";
      icon = "${config.home.homeDirectory}/.config/icons/sm64ex-coop.png";
      type = "Application";
      categories = [ "Game" "X-Port" ];
      comment = "N64 Port";
      terminal = false;
    };
  };
}
