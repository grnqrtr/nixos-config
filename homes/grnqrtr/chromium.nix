{ config, pkgs, ... }:

let
  # Fetch and extract the ZIP file.
  lineIconZip = pkgs.fetchzip {
    url = "https://d.line-scdn.net/stf/line-lp/top/LINE_Brand_icon.zip";
    sha256 = "H67xmE0BhNYm+8ESqHwoCJ95kX219kAeZQAmDJdO2YU=";
  };
  # Assuming the zip extracts to a directory and contains LINE_Brand_icon.png at its root.
  lineIconPath = "${lineIconZip}/LINE_Brand_icon.png";

  # Fetch Cubeast icon. Replace the URL and hash with the correct values.
  cubeastIcon = builtins.fetchurl {
    url = "https://app.cubeast.com/favicon.png";  # example URL; adjust as needed
    sha256 = "0cxpkbv6j7pxwzwf94d0nzv07q2z5nbm1pdmcbz00sfwqrqqcvbf";
  };

in {
  # Install Chromium
  home.packages = with pkgs; [ chromium ];

  # Place the extracted icon in your desired location.
  home.file = {
    ".config/icons/line.png".source = lineIconPath;
    ".config/icons/cubeast.png".source = cubeastIcon;
  };

  # Create the desktop entry for Line.
  xdg.desktopEntries = {
    line = {
      name = "Line";
      exec = "chromium --app=chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html";
      icon = "${config.home.homeDirectory}/.config/icons/line.png";
      type = "Application";
      # Desktop entry categories are standardized; for Line (an IM client) we could use:
      categories = [ "Network" "InstantMessaging" ];
      comment = "Line Messaging Client";
      terminal = false;
    };
    # Desktop entry for Cubeast
    cubeast = {
      name = "Cubeast";
      exec = "chromium --app=https://app.cubeast.com";
      icon = "${config.home.homeDirectory}/.config/icons/cubeast.png";
      type = "Application";
      categories = [ "Network" "Game" ];
      comment = "Cubeast Web Application";
      terminal = false;
    };
  };
}
