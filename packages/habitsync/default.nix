{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, maven
, makeWrapper
, nodejs
, jdk
}:

let
  version = "0.16.6";

  src = fetchFromGitHub {
    owner = "jofoerster";
    repo = "habitsync";
    tag = "v${version}";
    hash = "sha256-nS44JTvFjbzLMJrym1Oh2g7Iyl+J56m8s4AbMU76Ypk=";
  };

  habitsync-ui = buildNpmPackage {
    pname = "habitsync-ui";
    inherit version src;

    sourceRoot = "source/habitsync-ui";

    npmDepsHash = "sha256-eGuqud94El5SPZRZoMEgUo1wqwQsRfqWOckxPlqLWi4=";

    nativeBuildInputs = [ nodejs ];

    buildPhase = ''
      runHook preBuild
      npx expo export --platform web
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };

  habitsync-api = maven.buildMavenPackage {
    pname = "habitsync-api";
    inherit version src;

    sourceRoot = "source/habitsync-api";

    patches = [ ./data-dir.patch ];

    mvnHash = "sha256-/IlnUV8/IwDtSXdlbj6w8Rmn4/CVLWNz1GekhSDX+Sg=";

    nativeBuildInputs = [ jdk ];

    preBuild = ''
      mkdir -p src/main/resources/static
      cp -r ${habitsync-ui}/* src/main/resources/static/
    '';

    mvnParameters = "-DskipTests";

    installPhase = ''
      mkdir -p $out/share/java
      cp target/habitsync-api-*.jar $out/share/java/habitsync.jar
    '';
  };

in stdenv.mkDerivation {
  pname = "habitsync";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    makeWrapper ${jdk}/bin/java $out/bin/habitsync \
      --add-flags "-jar ${habitsync-api}/share/java/habitsync.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Self-hostable habit tracking platform";
    homepage = "https://github.com/jofoerster/habitsync";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryanc-me ];
    platforms = platforms.linux;
    mainProgram = "habitsync";
  };
}
