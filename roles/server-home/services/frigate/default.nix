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
    sops.secrets."frigate" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/frigate.env;
      key = "";
      owner = "frigate";
    };
    sops.secrets."go2rtc" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/go2rtc.env;
      key = "";
      owner = "frigate";
    };

    users.users.frigate.extraGroups = [
      "render"
    ];

    services.frigate = {
      enable = true;
      hostname = "${hostname}";
      vaapiDriver = "iHD";

      preCheckConfig = ''
        export FRIGATE_MQTT_PASSWORD=validation-placeholder
        export FRIGATE_INSIDE_ONVIF_PASSWORD=validation-placeholder
      '';

      settings = import ../../../../secrets/nix/frigate.nix {
        inherit lib pkgs;
      };
      nginxAuthRequest = ''
        auth_request /outpost.goauthentik.io/auth/nginx;
        error_page 401 = @goauthentik_proxy_signin;

        auth_request_set $authentik_user   $upstream_http_x_authentik_username;
        auth_request_set $authentik_groups $upstream_http_x_authentik_groups;
        auth_request_set $auth_cookie      $upstream_http_set_cookie;

        proxy_set_header Remote-User   $frigate_user;
        proxy_set_header Remote-Groups $frigate_groups;
        proxy_set_header Remote-Role   $frigate_role;

        add_header Set-Cookie $auth_cookie always;
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

        EnvironmentFile = config.sops.secrets."frigate".path;
      };
      preStart = ''
        # for some reason, semaphores are not being cleaned-up on restart. might
        # relate to the slow shutdown?
        find /dev/shm -maxdepth 1 -user frigate -delete 2>/dev/null || true
      '';
    };
    systemd.services.go2rtc = {
      serviceConfig = {
        EnvironmentFile = config.sops.secrets."go2rtc".path;
      };
    };

    # so Nginx can access Frigate's files (through MergerFS mount, which doesn't
    # look at supplimentary groups)
    systemd.services.masaq-frigate-perms = {
      description = "Ensure Nginx can read Frigate media files";

      wantedBy = [ "multi-user.target" ];
      before = [ "frigate.service" ];
      requiredBy = [ "frigate.service" ];

      path = with pkgs; [
        acl
        findutils
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        set -eu
        dir=/mnt/torrent-data/frigate
        if [ -d "$dir" ]; then
          setfacl -R -m u:nginx:rX "$dir"
          setfacl -R -m d:u:nginx:rX "$dir"
        fi
      '';
    };

    services.nginx.appendHttpConfig = ''
      geo $frigate_hass_bypass {
        default 0;
        10.1.1.128 1;
      }

      map $frigate_hass_bypass $frigate_user {
        1 home-assistant;
        default $authentik_user;
      }

      map $frigate_hass_bypass $frigate_groups {
        1 admin;
        default $authentik_groups;
      }

      map $authentik_groups $frigate_authentik_role {
        default viewer;
        "~(^|\|)admin($|\|)" admin;
      }

      map $frigate_hass_bypass $frigate_role {
        1 admin;
        default $frigate_authentik_role;
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

        #include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};
        absolute_redirect off;
        location /outpost.goauthentik.io {
          # allow hass without auth
          if ($frigate_hass_bypass) {
            return 204;
          }

          proxy_pass              https://127.0.0.1:9443/outpost.goauthentik.io;
          proxy_set_header        Host $host;
          proxy_set_header        X-Original-URL $scheme://$http_host$request_uri;
          proxy_set_header        X-Forwarded-Proto $scheme;
          proxy_set_header        X-Forwarded-Host $http_host;
          proxy_set_header        X-Forwarded-Uri $request_uri;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;

          proxy_set_header        Cookie $http_cookie;
          add_header              Set-Cookie $auth_cookie always;
          auth_request_set        $auth_cookie $upstream_http_set_cookie;

          proxy_pass_request_body off;
          proxy_set_header        Content-Length "";
        }
        location @goauthentik_proxy_signin {
          internal;
          add_header Set-Cookie $auth_cookie always;
          return 302 /outpost.goauthentik.io/start?rd=$scheme://$http_host$request_uri;
        }
      '';

      locations."/" = {
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
    };
    mine.server-auth.services.authentik.proxyApplications.frigate = {
      namePretty = "Frigate";
      group = "Home";
      assignedGroups = [ "user-home" ];
    };
  };
}
