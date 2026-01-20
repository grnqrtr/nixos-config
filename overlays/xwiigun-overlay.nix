final: prev: {
  xwiigun = prev.stdenv.mkDerivation rec {
    pname = "xwiigun";
    version = "git-master";

    src = prev.fetchFromGitHub {
      owner = "hifi";
      repo = "xwiigun";
      rev = "master";
      hash = "sha256-2mPTik3ApnJIbSJ7qtI7IIfslMcpPotryXuPAZxIPW4=";
    };

    buildInputs = [
      prev.xwiimote
      prev.SDL2
      prev.SDL2_gfx
    ];

    postPatch = ''
      substituteInPlace Makefile --replace "gcc" "cc"
    '';

    buildPhase = ''
      runHook preBuild
      make
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 xwiigun-mouse "$out/bin/xwiigun-mouse"
      install -Dm755 xwiigun-test "$out/bin/xwiigun-test"
      install -Dm755 libxwiigun.so "$out/lib/libxwiigun.so"
      runHook postInstall
    '';
  };
}
