final: prev:

let
  lib = prev.lib;
  fetchurl = prev.fetchurl;
  stdenv = prev.stdenv;
in
{
  phoenixd = prev.phoenixd.overrideAttrs (old: rec {
    version = "0.7.0";

    src =
      let
        selectSystem = attrs:
          attrs.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

        suffix = selectSystem {
          aarch64-darwin = "macos-arm64";
          x86_64-darwin  = "macos-x64";
          x86_64-linux   = "linux-x64";
          aarch64-linux  = "linux-arm64";
        };
      in
      fetchurl {
        url = "https://github.com/ACINQ/phoenixd/releases/download/v${version}/phoenixd-${version}-${suffix}.zip";
        # Type-qualified fake hashes so Nix will accept them and produce the real one.
        hash = selectSystem {
          aarch64-darwin = "sha256-0000000000000000000000000000000000000000000=";
          x86_64-darwin  = "sha256-0000000000000000000000000000000000000000000=";
          x86_64-linux   = "sha256-2oVnY/BjSC3HxfOMlqWyI/Yue3PT+vNWten4ty2DZVk=";
          aarch64-linux  = "sha256-0000000000000000000000000000000000000000000=";
        };
      };
  });
}
