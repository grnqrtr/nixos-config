{ config, pkgs, ... }:

{

  # Currently need to manually download the binaries and mod pack.
  # https://github.com/fgsfdsfgs/perfect_dark
  # https://github.com/jonaeru/perfect_dark/releases/tag/allinone-latest

  # Download the icon
  home.file = {
    ".config/icons/pd.png".source = builtins.fetchurl {
      url = "https://cdn2.steamgriddb.com/icon/64314c17210c549a854f1f1c7adce8b6/32/256x256.png";
      sha256 = "111e4e08510dcab77b47860208723f525769530ebfcd08c7ed09e224e9c41ff1";
    };
  };

  # Add desktop entries
  xdg.desktopEntries = {
    perfectdark = {
      name = "Perfect Dark";
      exec = "steam-run \"${config.home.homeDirectory}/Games/N64/Perfect Dark PC Port/pd.x86_64\"";
      icon = "${config.home.homeDirectory}/.config/icons/pd.png";
      type = "Application";
      categories = [ "Game" "X-Port" ];
      comment = "N64 Port";
      terminal = false;
    };
    perfectdarkplus = {
      name = "Perfect Dark +";
      exec = "steam-run \"${config.home.homeDirectory}/Games/N64/Perfect Dark PC Port/pd.jonaeru.x86_64\" --moddir mods/mod_allinone --gexmoddir mods/mod_gex --kakarikomoddir mods/mod_kakariko --darknoonmoddir mods/mod_dark_noon --log";
      icon = "${config.home.homeDirectory}/.config/icons/pd.png";
      type = "Application";
      categories = [ "Game" "X-Port" ];
      comment = "N64 Port";
      terminal = false;
    };
  };

}
