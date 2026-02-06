{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22,
  yarn,
  fetchYarnDeps,
  yarnConfigHook,
  yarnInstallHook,
  yarnBuildHook,
  makeWrapper,
  python3,
  pkg-config,
  vips,
  libcxx,
  openssl,
  zlib,
  glibc,
  gnumake,
  which,
  gcc,
  binutils,
  ...
}:

let
  version = "6.16.1";
  rev = "refs/tags/v${version}";
  srcHash = "sha256-hQI52ZIVrXZjtUyCCnlHHhTOzYQJHbh/nXqTzT4DYzE=";

  src = fetchFromGitHub {
    owner = "TryGhost";
    repo = "Ghost";
    inherit rev;
    hash = srcHash;

    fetchSubmodules = true;
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-GUmaBXZeML4yrUle0FwexVudNSYxQff7ECqVJOz9OR4=";
  };

  yarn_node22 = yarn.override { nodejs = nodejs_22; };

  ghostBuild = stdenv.mkDerivation {
    pname = "ghost-cms-build";
    inherit version src yarnOfflineCache;

    nativeBuildInputs = [
      nodejs_22
      yarn_node22
      yarnConfigHook
      yarnInstallHook
      yarnBuildHook
      python3
      pkg-config
    ];

    buildInputs = [
      vips
      openssl
      zlib
      libcxx
    ];

    postPatch = ''
      substituteInPlace apps/admin/package.json \
        --replace 'tsc -b && vite build' \
                  'tsc -b && node ./node_modules/vite/bin/vite.js build'
    '';

    preConfigure = ''
      export HOME="$TMPDIR/home"
      mkdir -p "$HOME"
    '';

    # your existing build tweaks
    buildPhase = ''
      runHook preBuild

      export CI=1
      export NX_DAEMON=false
      export NX_TUI=false
      export NX_TASKS_RUNNER_DYNAMIC_OUTPUT=false
      export FORCE_COLOR=0
      export TERM=dumb

      # Whatever you need to make vite/nx happy during build
      patchShebangs node_modules/.bin || true
      patchShebangs apps/admin/node_modules/.bin || true
      patchShebangs ghost/*/node_modules/.bin || true

      # build + create the ghost/core/ghost-*.tgz
      yarn --offline build

      # you had to do this to avoid the npm pack script panic/path issues
      echo "ignore-scripts=true" >> .npmrc
      yarn --offline nx run ghost:archive --output-style=stream

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/artifacts"
      mkdir -p "$out/artifacts/vendor"

      # copy the build archive
      cp -v ./ghost/core/ghost-${version}.tgz "$out/artifacts/"

      # and project files needed for `npm install` later
      cp -v ./package.json "$out/artifacts/package.json"
      cp -v ./yarn.lock "$out/artifacts/yarn.lock"

      # and any deps from the package.json that are sourced *locally* (i.e., they
      # have a version like "0.0.0" and are expected to exist in the monorepo)
      cp -R --reflink=auto ./ghost/i18n "$out/artifacts/vendor/i18n"
      cp -R --reflink=auto ./ghost/parse-email-address "$out/artifacts/vendor/parse-email-address"

      # make sure to kill any node_modules, as they have symlinks out to folders
      # that we aren't copying, which makes Nix angry
      find "$out/artifacts/vendor" -name "node_modules" -maxdepth 2 -type d -exec rm -rf {} + || true

      runHook postInstall
    '';
  };

  ghostRuntime = stdenv.mkDerivation {
    pname = "ghost-cms";
    inherit version yarnOfflineCache;
    src = ghostBuild;

    nativeBuildInputs = [
      nodejs_22
      nodejs_22.dev
      yarn_node22
      makeWrapper
      python3
      pkg-config
      gnumake
      which
      stdenv.cc
      stdenv.cc.bintools
    ];

    buildInputs = [
      vips
      openssl
      zlib
    ];

    unpackPhase = ''
      cp -R --no-preserve=mode,ownership "${ghostBuild}/artifacts" ./artifacts
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/ghost" "$out/bin"

      cp -v ./artifacts/package.json "$out/share/ghost/package.json"
      cp -v ./artifacts/yarn.lock "$out/share/ghost/yarn.lock"

      mkdir -p "$out/share/ghost/ghost/core"
      tar -xzf "./artifacts/ghost-${version}.tgz" -C "$out/share/ghost/ghost/core" --strip-components=1

      cp -R --reflink=auto ./artifacts/vendor/i18n "$out/share/ghost/ghost/i18n"
      cp -R --reflink=auto ./artifacts/vendor/parse-email-address "$out/share/ghost/ghost/parse-email-address"

      work="$TMPDIR/ghost-runtime"
      mkdir -p "$work"
      cp -R --no-preserve=mode,ownership "$out/share/ghost/." "$work/"
      chmod -R u+w "$work"

      export HOME="$TMPDIR/home"
      mkdir -p "$HOME"

      pushd "$work"
        yarn config set yarn-offline-mirror "${yarnOfflineCache}" >/dev/null
        yarn config set yarn-offline-mirror-pruning false >/dev/null

        # for node-gyp
        export npm_config_nodedir="${nodejs_22.dev}"
        export npm_config_build_from_source=true

        yarn install \
          --offline \
          --production \
          --ignore-engines \
          --non-interactive \
          --frozen-lockfile
      popd

      # Copy the fully materialized install into $out
      rm -rf "$out/share/ghost"
      mkdir -p "$out/share/ghost"
      cp -R --no-preserve=mode,ownership "$work/." "$out/share/ghost/"

      makeWrapper ${nodejs_22}/bin/node "$out/bin/ghost" \
        --chdir "$out/share/ghost/ghost/core" \
        --set-default NODE_ENV production \
        --add-flags "$out/share/ghost/ghost/core/index.js"

      runHook postInstall
    '';
  };
in
ghostRuntime
