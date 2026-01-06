{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.sabnzbd;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.sabnzbd = {
    enable = mkEnableOption "sabnzbd (TV shows)";
  };

  config = mkIf cfg.enable {
    services.sabnzbd = {
      enable = true;
    };

    users.users."sabnzbd".extraGroups = [
      "usenet-data"
      "media-tv"
      "media-movies"
      "media-music"
    ];
    users.users."ryan".extraGroups = lib.optionals config.mine.users.ryan.enable [
      "usenet-data"
    ];

    # for `par2`
    environment.systemPackages = [
      pkgs.par2cmdline
    ];

    services.nginx.virtualHosts."sabnzbd.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../../secrets/oauth2-proxy/snippets/main.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:5959";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
