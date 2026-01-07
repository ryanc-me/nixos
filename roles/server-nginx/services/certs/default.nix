{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-nginx.services.certs;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-nginx.services.certs = {
    enable = mkEnableOption "acme certs";
  };

  config = mkIf cfg.enable {
    sops.secrets."cloudflare-api-token" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/acme-cloudflare.env;
      key = "";
    };
  };
}
