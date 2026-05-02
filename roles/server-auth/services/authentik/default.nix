{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    concatStringsSep
    mapAttrsToList
    ;
  cfg = config.mine.server-auth.services.authentik;
  nginx = config.mine.server-nginx.services.nginx;

  blueprintsDir = "/var/lib/authentik/blueprints-custom";
  lockFile = "/run/authentik-blueprints.lock";

  copyCustomBlueprints = concatStringsSep "\n" (
    mapAttrsToList (name: path: ''
      install -m 0644 ${path} "$tmp/${name}.yaml"
    '') cfg.blueprints
  );

  prepareBlueprintsScript = pkgs.writeShellScript "prepare-authentik-blueprints" ''
    set -euo pipefail

    exec 9>${lockFile}
    ${pkgs.util-linux}/bin/flock 9

    tmp="$(mktemp -d /var/lib/authentik/blueprints-custom.tmp.XXXXXX)"
    trap 'rm -rf "$tmp"' EXIT

    cp -r --no-preserve=mode,ownership \
      ${config.services.authentik.authentikComponents.staticWorkdirDeps}/blueprints/. \
      "$tmp/"

    ${copyCustomBlueprints}

    chown -R root:root "$tmp"
    find "$tmp" -type d -exec chmod 0755 {} +
    find "$tmp" -type f -exec chmod 0644 {} +

    rm -rf ${blueprintsDir}.old
    if [ -e ${blueprintsDir} ]; then
      mv ${blueprintsDir} ${blueprintsDir}.old
    fi
    mv "$tmp" ${blueprintsDir}
    rm -rf ${blueprintsDir}.old

    trap - EXIT
  '';
in
{
  options.mine.server-auth.services.authentik = {
    enable = mkEnableOption "authentik service";

    blueprints = mkOption {
      type = types.attrsOf types.path;
      default = { };
      description = "Extra authentik blueprints to expose to authentik.";
    };
  };

  config = mkIf cfg.enable {

    sops.secrets."authentik-env" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/authentik.env;
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/authentik 0755 root root - -"
      "d /var/lib/authentik/certs 0750 authentik authentik - -"
      "d ${blueprintsDir} 0755 root root - -"
    ];

    systemd.services.authentik.serviceConfig.ExecStartPre = lib.mkBefore [
      "+${prepareBlueprintsScript}"
    ];

    systemd.services.authentik-worker.serviceConfig.ExecStartPre = lib.mkBefore [
      "+${prepareBlueprintsScript}"
    ];

    services.authentik = {
      enable = true;

      environmentFile = config.sops.secrets."authentik-env".path;

      nginx.enable = false; # we'll do it ourselves
      settings = {
        blueprints_dir = "/var/lib/authentik/blueprints-custom";
        cert_discovery_dir = "/var/lib/authentik/certs";
        cookie_domain = config.mine.server-nginx.domainBase;
        listen = {
          http = "127.0.0.1:5080";
          https = "127.0.0.1:5443";
        };
      };
    };

    services.nginx = {
      virtualHosts."auth.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null; # because we're using DNS-01
        http2 = true;

        locations."/" = {
          proxyPass = "https://127.0.0.1:5443";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}
