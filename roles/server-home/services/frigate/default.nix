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
  options.mine.server-home.services.frigate = {
    enable = mkEnableOption "frigate (NVR)";
  };

  config = mkIf cfg.enable {
    services.frigate = {
      enable = true;
      hostname = "${hostname}";
      settings = import ../../../../secrets/nix/frigate.nix {
        inherit lib pkgs;
      };
    };
    services.go2rtc = {
      enable = true;

      settings = import ../../../../secrets/nix/go2rtc.nix {
        inherit lib pkgs;
      };
    };
    users.users.frigate.extraGroups = [
      "render"
    ];
    systemd.services.frigate = {
      serviceConfig = {
        AmbientCapabilities = [ "CAP_PERFMON" ];
        CapabilityBoundingSet = [ "CAP_PERFMON" ];
      };
      # for some reason, semaphores are not being cleaned-up on restart. might
      # relate to the slow shutdown?
      preStart = ''
        find /dev/shm -maxdepth 1 -user frigate -delete 2>/dev/null || true
      '';
    };

    services.nginx.virtualHosts.${hostname} = mkIf nginx.enable {
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
        # priority = 1;
        # extraConfig = ''
        #   include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        # '';
      };
    };
  };
}
