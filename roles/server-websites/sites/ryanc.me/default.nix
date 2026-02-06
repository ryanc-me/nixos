{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-websites.sites.ryanc-me;
  nginx = config.mine.server-nginx.services.nginx;

  hooksJson = ./hooks.json;
in
{
  options.mine.server-websites.sites.ryanc-me = {
    enable = mkEnableOption "www.ryanc.me site configuration";
  };

  config = mkIf cfg.enable {
    # sops.secrets."eleventy-token" = {
    #   format = "dotenv";
    #   sopsFile = ../../../../secrets/eleventy-token.env;
    #   key = "";
    # };
    # systemd.services.nginx.serviceConfig.EnvironmentFile = config.sops.secrets."eleventy-token".path;
    # services.nginx.appendConfig = ''
    #   env ELEVENTY_TOKEN;
    # '';
    # services.nginx.httpConfig = ''
    #   map $uri $rebuild_allowed {
    #     default 0;
    #     "~^/__rebuild/$WWW_REBUILD_TOKEN$" 1;
    #   }
    # '';

    users.users.wwwbuild = {
      isSystemUser = true;
      group = "wwwbuild";
    };
    users.groups.wwwbuild = { };

    systemd.tmpfiles.rules = [
      "d /var/lib/www.ryanc.me 0750 wwwbuild wwwbuild - -"
      "d /var/lib/www.ryanc.me/repo 0750 wwwbuild wwwbuild - -"
      "d /srv/www/www.ryanc.me 0755 root root - -"
      "d /srv/www/www.ryanc.me/releases 0755 root root - -"
    ];

    services.nginx.virtualHosts."www.ryanc.me" = {
      forceSSL = true;
      useACMEHost = "ryanc.me";
      acmeRoot = null;
      http2 = true;

      root = "/srv/www/www.ryanc.me/current";

      locations."/" = {
        extraConfig = ''
          try_files $uri $uri/ =404;
        '';
      };

      locations."/content/images" = {
        root = "/var/lib/ghost-cms";
      };
      locations."/content/files" = {
        root = "/var/lib/ghost-cms";
      };
    };

    systemd.services.www-ryanc-me-build = {
      description = "Build www.ryanc.me";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      path = [
        pkgs.git
        pkgs.yarn
        pkgs.nodejs
        pkgs.coreutils
        pkgs.gnused
        pkgs.gawk
      ];

      script = ''
        set -euo pipefail

        yarn install --frozen-lockfile
        yarn build

        ts="$(date +%Y%m%d%H%M%S)"
        out="/srv/www/www.ryanc.me/releases/$ts"
        mkdir -p "$out"

        # Adjust if your build output dir differs
        cp -a ./dist/. "$out/"

        ln -sfn "$out" /srv/www/www.ryanc.me/current
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "wwwbuild";
        Group = "wwwbuild";
        WorkingDirectory = "/var/lib/www.ryanc.me/repo";
        EnvironmentFile = "/var/lib/www.ryanc.me/env";
      };
    };

    systemd.services.www-ryanc-me-webhook = {
      description = "Local webhook for Ghost -> www.ryanc.me rebuild";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.webhook}/bin/webhook -ip 127.0.0.1 -port 9123 -hooks ${hooksJson}";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };
}
