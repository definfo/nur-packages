{
  lib,
  stdenv,
  fetchFromGitLab,
  bobcat,
  icmake,
  yodl,
}:

stdenv.mkDerivation rec {
  pname = "flexc++";
  version = "2.16.00";

  src = fetchFromGitLab {
    owner = "fbb-git";
    repo = "flexcpp";
    rev = version;
    hash = "sha256-hnsWJATdA24kxuOmH7x8HMH9nPFXAAThofXvshuWk0s=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */flexc++)
  '';

  buildInputs = [ bobcat ];
  nativeBuildInputs = [
    icmake
    yodl
  ];

  postPatch = ''
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs .
  '';

  buildPhase = ''
    ./build man
    ./build manual
    ./build program
  '';

  installPhase = ''
    ./build install x
  '';

  meta = with lib; {
    description = "C++ tool for generating lexical scanners";
    mainProgram = "flexc++";
    longDescription = ''
      Flexc++ was designed after `flex'. Flexc++ offers a cleaner class design
      and requires simpler specification files than offered by flex's C++
      option.
    '';
    homepage = "https://fbb-git.github.io/flexcpp/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
