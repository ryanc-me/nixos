{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  openssl,
  ffmpeg,
  v4l-utils,
  xxd,
  git,
  which,
}:

stdenv.mkDerivation rec {
  pname = "camera-streamer";
  version = "0-unstable-2026-04-19";

  src = fetchFromGitHub {
    owner = "ayufan-research";
    repo = "camera-streamer";
    rev = "e17a86e4f9bd0fda4bd901f14a5e2eef682962f8";
    hash = "sha256-umU8Rp8+wUvQCNK8OpgND/6gPD013SB6sdXSLy5UGAQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    xxd
    git
    which
  ];

  buildInputs = [
    openssl
    ffmpeg
    v4l-utils
  ];

  dontConfigure = true;
  hardeningDisable = [ "fortify" ];

  postPatch = ''
    substituteInPlace Makefile --replace "-Werror " ""
    substituteInPlace Makefile \
      --replace 'git submodule update --init --recursive $(LIBDATACHANNEL_PATH)' ""
  '';

  makeFlags = [
    "USE_RTSP=0"
    "USE_LIBCAMERA=0"
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${openssl.dev}/include"
  ];

  NIX_LDFLAGS = [
    "-L${openssl.out}/lib"
  ];

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 camera-streamer $out/bin/camera-streamer
    runHook postInstall
  '';

  meta = with lib; {
    description = "Camera streaming server";
    homepage = "https://github.com/ayufan-research/camera-streamer";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "camera-streamer";
  };
}
