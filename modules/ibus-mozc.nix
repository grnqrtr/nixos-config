{ config, pkgs, ... }:

{

  # Enable Japanese input using ibus and Mozc
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ mozc ];
  };

}
