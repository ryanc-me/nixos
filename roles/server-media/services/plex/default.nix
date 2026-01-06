{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.plex;
  nginx = config.mine.server-nginx.services.nginx;

  nginxConfig = ''
    include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
    include ${../../../server-nginx/services/nginx/snippets/ssl-compat.conf};

    #Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
    send_timeout 100m;

    # Nginx default client_max_body_size is 1MB, which breaks Camera Upload feature from the phones.
    # Increasing the limit fixes the issue. Anyhow, if 4K videos are expected to be uploaded, the size might need to be increased even more
    client_max_body_size 100M;

    # Plex headers
    proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
    proxy_set_header X-Plex-Device $http_x_plex_device;
    proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
    proxy_set_header X-Plex-Platform $http_x_plex_platform;
    proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
    proxy_set_header X-Plex-Product $http_x_plex_product;
    proxy_set_header X-Plex-Token $http_x_plex_token;
    proxy_set_header X-Plex-Version $http_x_plex_version;
    proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
    proxy_set_header X-Plex-Provides $http_x_plex_provides;
    proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
    proxy_set_header X-Plex-Model $http_x_plex_model;

    # Websockets
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    # Buffering off send to the client as soon as the data is received from Plex.
    proxy_redirect off;
    proxy_buffering off;
  '';
in
{
  # sources:
  # https://nixos.wiki/wiki/Plex
  # https://github.com/toomuchio/plex-nginx-reverseproxy/blob/master/nginx.conf

  options.mine.server-media.services.plex = {
    enable = mkEnableOption "Plex (media server)";
  };

  config = mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true;
    };

    users.users."plex".extraGroups = [
      "media-movies"
      "media-tv"
      "media-music"
    ];

    services.nginx.virtualHosts."plex.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;
      extraConfig = nginxConfig;

      locations."/".return = "303 /web/index.html";
      locations."/web" = {
        proxyPass = "http://localhost:32400";
      };
    };

    # redirects
    services.nginx.virtualHosts."${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null;
      locations."/".return = "303 https://plex.mixeto.io$request_uri";
    };
    services.nginx.virtualHosts."www.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null;
      locations."/".return = "303 https://plex.mixeto.io$request_uri";
    };
  };
}
