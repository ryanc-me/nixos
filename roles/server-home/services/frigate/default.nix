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

  frigateBlueprint = pkgs.writeText "authentik-frigate.yaml" ''
    version: 1
    metadata:
      name: frigate
      labels:
        blueprints.goauthentik.io/instantiate: "true"

    entries:
      - model: authentik_providers_proxy.proxyprovider
        identifiers:
          name: Frigate
        attrs:
          name: Frigate
          mode: forward_single
          external_host: https://frigate.mixeto.io
          internal_host: ""
          authorization_flow: !Find [authentik_flows.flow, [slug, default-provider-authorization-implicit-consent]]
          invalidation_flow: !Find [authentik_flows.flow, [slug, default-provider-invalidation-flow]]
          internal_host_ssl_validation: true
          intercept_header_auth: true
          cookie_domain: ""
          basic_auth_enabled: false
          skip_path_regex: ""

      - model: authentik_core.application
        identifiers:
          slug: frigate
        attrs:
          name: Frigate
          slug: frigate
          group: Home
          meta_icon: https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/svg/frigate.svg
          meta_launch_url: ""
          open_in_new_tab: false
          policy_engine_mode: any
          provider: !Find [authentik_providers_proxy.proxyprovider, [name, Frigate]]
  '';
in
{
  options.mine.server-home.services.frigate = {
    enable = mkEnableOption "frigate (NVR)";
  };

  config = mkIf cfg.enable {
    mine.server-auth.services.authentik.blueprints.frigate = frigateBlueprint;

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
