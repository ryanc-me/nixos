{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-databases.services.mosquitto;
  nginx = config.mine.server-nginx.services.nginx;

in
{
  options.mine.server-databases.services.mosquitto = {
    enable = mkEnableOption "mosquitto service";
  };

  config = mkIf cfg.enable {
    sops = {
      secrets = {
        "mosquitto-users/frigate" = {
          sopsFile = ../../../../secrets/mosquitto.yaml;
        };
        "mosquitto-users/homeAssistant" = {
          sopsFile = ../../../../secrets/mosquitto.yaml;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 1883 ];
    services.mosquitto = {
      enable = true;
      listeners = [
        {
          address = "10.1.1.100";
          port = 1883;
          # protocol = "mqtt";

          users = {
            "frigate" = {
              acl = [
                "readwrite #"
              ];
              passwordFile = config.sops.secrets."mosquitto-users/frigate".path;
            };
            "homeAssistant" = {
              acl = [
                "readwrite #"
              ];
              passwordFile = config.sops.secrets."mosquitto-users/homeAssistant".path;
            };
          };
        }
      ];
    };
  };
}
