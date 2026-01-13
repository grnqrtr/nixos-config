final: prev: {
  xwiimote-mouse = prev.stdenv.mkDerivation rec {
    pname = "xwiimote-mouse";
    version = "git-master";

    src = prev.fetchFromGitHub {
      owner = "MrApplejuice";
      repo = "xwiimote-mouse-driver";
      rev = "master";
      hash = "sha256-6c1b26srUQEK81qTQnp8JM+WFN2Q8SiUVmCNbhWEdFA=";
    };

    python = prev.python3.withPackages (ps: [
      ps.numpy
      ps.tkinter
    ]);

    sockppSrc = prev.fetchurl {
      url = "https://github.com/fpagliughi/sockpp/archive/refs/tags/v1.0.0.tar.gz";
      hash = "sha256-gYR3+ubrKbnarO9xo9DElN6eSPb9Jnp/xaTDMtshG8U=";
    };

    nativeBuildInputs = [
      prev.cmake
      prev.pkg-config
      prev.makeWrapper
    ];

    buildInputs = [
      prev.xwiimote
      prev.systemd
      prev.libevdev
      prev.ncurses
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace "https://github.com/fpagliughi/sockpp/archive/refs/tags/v1.0.0.tar.gz" "${sockppSrc}" \
        --replace "lib/libsockpp.a" "lib64/libsockpp.a"
    '';

    configurePhase = ''
      runHook preConfigure
      cmake -S . -B build \
        -DCMAKE_BUILD_TYPE=Release
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild
      cmake --build build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      candidate="$(find build -type f -perm -111 \
        \( -name 'xwiimote-mouse' -o -name 'xwiimote-mouse-driver' \) | head -n1)"
      if [ -z "$candidate" ]; then
        echo "Could not find built xwiimote-mouse binary" >&2
        exit 1
      fi
      install -Dm755 "$candidate" "$out/bin/xwiimote-mouse"
      if [ "$(basename "$candidate")" != "xwiimote-mouse" ]; then
        ln -s "$out/bin/xwiimote-mouse" "$out/bin/$(basename "$candidate")"
      fi
      install -Dm644 src/py/configurator.py \
        "$out/share/xwiimote-mouse/configurator.py"
      makeWrapper "${python}/bin/python" "$out/bin/xwiimote-mouse-config" \
        --add-flags "$out/share/xwiimote-mouse/configurator.py"
      runHook postInstall
    '';
  };
}
