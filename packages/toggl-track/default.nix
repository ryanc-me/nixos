{
  lib,
  stdenvNoCC,
  makeWrapper,
  makeDesktopItem,
  microsoft-edge,
}:

let
  # category options:
  # https://specifications.freedesktop.org/menu/latest/category-registry.html

  appId = "toggl-track";
  appName = "Toggl Track";
  url = "https://track.toggl.com/";
  startupWmClass = "msedge-track.toggl.com__-Default";
  iconFile = ./toggl-track.svg;
  description = "Toggl Track PWA launcher using Microsoft Edge";
  categories = [
    "Utility"
  ];

  desktopItem = makeDesktopItem {
    name = appId;
    desktopName = appName;
    comment = description;
    categories = categories;
    terminal = false;

    exec = "${appId} %U";
    icon = lib.foldl' (acc: ext: lib.removeSuffix ext acc) (builtins.baseNameOf iconFile) [
      ".svg"
      ".png"
      ".jpg"
    ];

    startupWMClass = startupWmClass;
  };
in
stdenvNoCC.mkDerivation {
  pname = appId;
  version = "1.0.0";

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ microsoft-edge ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps

    # Wrapper to launch Outlook in Edge app-mode
    makeWrapper ${lib.getExe microsoft-edge} $out/bin/${appId} \
      --add-flags "--app=${lib.escapeShellArg url}" \
      --add-flags "--class=${appId}" \
      --add-flags "--name=${appId}" \
      --add-flags "--profile-directory=Default" \
      --add-flags "--enable-features=UseOzonePlatform" \
      --add-flags "--ozone-platform-hint=auto"

    # Install desktop entry
    cp ${desktopItem}/share/applications/*.desktop $out/share/applications/

    # Install icon (SVG)
    install -m 0644 ${iconFile} \
      $out/share/icons/hicolor/scalable/apps/${builtins.baseNameOf iconFile}

    runHook postInstall
  '';

  meta = with lib; {
    description = description;
    homepage = url;
    platforms = platforms.linux;
    license = licenses.unfreeRedistributable;
    mainProgram = appId;
  };
}
