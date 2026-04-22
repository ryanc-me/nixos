{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.printer.services.fluidd;
in
{
  options.mine.printer.services.fluidd = {
    enable = mkEnableOption "fluidd service";
  };

  config = mkIf cfg.enable {
    services.fluidd = {
      enable = true;
      nginx = {
        locations = {
          "^~ /server/files/upload" = {
            proxyPass = "http://fluidd-apiserver$request_uri";
            extraConfig = ''
              proxy_request_buffering off;
              proxy_http_version 1.1;
            '';
          };
          "^~ /api/files/local" = {
            proxyPass = "http://fluidd-apiserver$request_uri";
            extraConfig = ''
              proxy_request_buffering off;
              proxy_http_version 1.1;
            '';
          };
          "/webcam-1/" = lib.mkIf config.mine.printer.services.mjpg-streamer.enable {
            proxyPass = "http://localhost:5050/";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_buffering off;
              proxy_request_buffering off;
              proxy_read_timeout 1d;
              proxy_send_timeout 1d;
              send_timeout 1d;
            '';
          };
        };
      };
    };
    services.nginx = {
      recommendedProxySettings = true;
      clientMaxBodySize = "0"; # for gcode uploads
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
