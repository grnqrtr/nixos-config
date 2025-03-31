{ config, pkgs, ... }:

{

  # Enable Japanese input using fcitx5 and mozc
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

}
