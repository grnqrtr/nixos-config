self: super: {
  sm64ex-coop-renamed = super.sm64ex-coop.overrideAttrs (oldAttrs: rec {
    installPhase = ''
      ${oldAttrs.installPhase}
      mv $out/bin/sm64ex $out/bin/sm64ex-coop
    '';
  });
}
