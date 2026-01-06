{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-nginx.services.nginx = {
    enable = mkEnableOption "Nginx";
  };

  config = mkIf cfg.enable {
    security.dhparams = {
      enable = true;
      params."nginx".bits = 3072;
    };
    services.nginx = {
      enable = true;

      sslDhparam = config.security.dhparams.params."nginx".path;

      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
