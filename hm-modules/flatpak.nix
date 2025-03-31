{ config, pkgs, ... }:

{

  services.flatpak = {
    enable = true;
    packages = [
      "org.gimp.GIMP//stable"
      "org.gimp.GIMP.Plugin.Resynthesizer//3"
      "com.pokemmo.PokeMMO//stable"
    ];
  };

}
