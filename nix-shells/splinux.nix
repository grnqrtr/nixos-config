{ pkgs ? import <nixpkgs> {} }:
  let
    libPath = with pkgs; lib.makeLibraryPath [
      libGL
      libxkbcommon
      wayland

      xorg.libX11
      xorg.libXcursor
      xorg.libxcb
      xorg.libXi

    ];
  in {
    devShell = with pkgs; mkShell {
      buildInputs = [
        cargo
        rustc
        rust-analyzer
      ];
      
      RUST_LOG = "debug";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      LD_LIBRARY_PATH = libPath;
    };
  }
