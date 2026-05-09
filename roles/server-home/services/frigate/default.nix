{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.frigate;
  nginx = config.mine.server-nginx.services.nginx;
  hostname = "frigate.${config.mine.server-nginx.domainBase}";
in
{
  disabledModules = [
    "services/video/frigate.nix"
  ];

  imports = [
    ./frigate.nix
  ];

  options.mine.server-home.services.frigate = {
    enable = mkEnableOption "frigate (NVR)";
  };

  config = mkIf cfg.enable {
    users.users.frigate.extraGroups = [
      "render"
    ];

    services.frigate = {
      enable = true;
      hostname = "${hostname}";
      vaapiDriver = "iHD";

      settings = import ../../../../secrets/nix/frigate.nix {
        inherit lib pkgs;
      };
      nginxAuthRequest = ''
        auth_request /outpost.goauthentik.io/auth/nginx;
        error_page 401 = @goauthentik_proxy_signin;

        auth_request_set $authentik_user   $upstream_http_x_authentik_username;
        auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
        auth_request_set $auth_cookie      $upstream_http_set_cookie;

        proxy_set_header Remote-User   $authentik_user;
        proxy_set_header Remote-Groups $authentik_groups;

        # Temporary hard-code for proof. Replace with a map later.
        proxy_set_header Remote-Role $frigate_role;

        add_header Set-Cookie $auth_cookie always;
        add_header X-Debug-AK-User "$authentik_user" always;
        add_header X-Debug-AK-Groups "$authentik_groups" always;
      '';
    };
    services.go2rtc = {
      enable = true;

      settings = import ../../../../secrets/nix/go2rtc.nix {
        inherit lib pkgs;
      };
    };
    systemd.services.frigate = {
      serviceConfig = {
        AmbientCapabilities = [ "CAP_PERFMON" ];
        CapabilityBoundingSet = [ "CAP_PERFMON" ];
      };
      preStart = ''
        # for some reason, semaphores are not being cleaned-up on restart. might
        # relate to the slow shutdown?
        find /dev/shm -maxdepth 1 -user frigate -delete 2>/dev/null || true

        # ensure Nginx can read data from the export/clip/recording directories
        # (required to play back recordings)
        for dir in /mnt/disks/SSD-*/frigate/{exports,clips,recordings}; do
          if [ -d "$dir" ]; then
            chgrp -R nginx "$dir"
            chmod -R g+rX "$dir"
            find "$dir" -type d -exec chmod g+s {} +
          fi
        done
      '';
    };

    services.nginx.appendHttpConfig = ''
      map $authentik_groups $frigate_role {
        default viewer;
        "~(^|\|)admin($|\|)" admin;
      }
    '';
    services.nginx.virtualHosts.${hostname} = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};
      '';

      locations."/" = {
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
    };
    mine.server-auth.services.authentik.proxyApplications.frigate = {
      namePretty = "Frigate";
    };
  };
}
