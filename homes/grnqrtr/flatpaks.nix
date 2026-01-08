{ config, pkgs, ... }:

{

  services.flatpak = {
    enable = true;
    packages = [
      "org.gimp.GIMP//stable"
      "org.gimp.GIMP.Plugin.Resynthesizer//3"
      "org.gnome.FontManager//stable"
      "com.pokemmo.PokeMMO//stable"
      "org.DolphinEmu.dolphin-emu//stable"
    ];
  };

}
