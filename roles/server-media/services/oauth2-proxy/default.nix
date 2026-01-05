{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.oauth2-proxy;
  nginx = config.mine.server-media.services.nginx;
in
{
  #TODO: move this to server-auth (server-oauth2-proxy?)
  options.mine.server-media.services.oauth2-proxy = {
    enable = mkEnableOption "oauth2-proxy (auth proxy)";
  };

  config = mkIf cfg.enable {
    sops.secrets."oauth2-proxy" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/oauth2-proxy.env;
      key = "";
    };

    services.oauth2-proxy = {
      enable = true;
      provider = "github";
      email.domains = [ "*" ];
      cookie.domain = ".mixeto.io";
      reverseProxy = true;
      extraConfig = {
        footer = "-"; # disable footer
        whitelist-domain = ".mixeto.io";
        skip-provider-button = "true";
      };
      upstream = [ "static://200" ];
      # nginx = {
      #   domain = "auth.${config.mine.server-media.domainBase}";
      # };

      # various secrets set by the key file:
      # - OAUTH2_PROXY_CLIENT_ID
      # - OAUTH2_PROXY_CLIENT_SECRET
      # - OAUTH2_PROXY_COOKIE_SECRET
      # - OAUTH2_PROXY_GITHUB_USERS
      keyFile = config.sops.secrets."oauth2-proxy".path;

    };
  };
}
