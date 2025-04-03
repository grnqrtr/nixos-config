{ config, pkgs, ... }:

{

  stylix = {
    enable = true;
    image = ../wallpaper-moon.jpg;
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    targets.vscode.profileNames = [ "default" ];
    targets.librewolf.profileNames = [ "Default" ];
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Workaround to set active hint color
  dconf.settings."org/gnome/shell/extensions/pop-shell" = {
    hint-color-rgba = "rgba(0, 255, 255, 1)";
  };

}
