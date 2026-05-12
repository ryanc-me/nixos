{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.home-assistant;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-home.services.home-assistant = {
    enable = mkEnableOption "home-assistant (central home automation server)";
  };

  config = mkIf cfg.enable {
    # frigate, go2rtc
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -i br0 -s 10.1.1.128 -p tcp --dport 8554 -j ACCEPT
      iptables -A nixos-fw -i br0 -s 10.1.1.128 -p tcp --dport 8555 -j ACCEPT
    '';
    networking.firewall.extraStopCommands = ''
      iptables -D nixos-fw -i br0 -s 10.1.1.128 -p tcp --dport 8554 -j ACCEPT 2>/dev/null || true
      iptables -D nixos-fw -i br0 -s 10.1.1.128 -p tcp --dport 8555 -j ACCEPT 2>/dev/null || true
    '';

    services.nginx.virtualHosts."home.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://10.1.1.128:8123";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        # extraConfig = ''
        #   include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        # '';
      };
    };
    mine.server-auth.services.authentik.proxyApplications.home-assistant = {
      namePretty = "Home Assistant";
      icon = "home-assistant";
      group = "Home";
      assignedGroups = [ "user-home" ];
    };
  };
}
