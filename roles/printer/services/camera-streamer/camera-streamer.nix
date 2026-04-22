{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  cfg = config.services.camera-streamer;
  camera-streamer = pkgs.callPackage ../../../../packages/camera-streamer/default.nix { };
in
{
  options = {
    services.camera-streamer = {
      enable = lib.mkEnableOption "camera-streamer";

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port for the camera-streamer web interface.";
      };
      interface = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Interface for the camera-streamer web interface.";
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Extra arguments to pass to the camera-streamer service.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.camera-streamer = {
        description = "camera-streamer - camera streaming server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "camera-streamer";
          ExecStart = "${lib.getExe camera-streamer} --http-listen=${cfg.interface} --http-port=${lib.toString cfg.port} ${lib.concatStringsSep " " cfg.extraArgs}";
          Restart = "on-failure";
        };
      };
    };
  };
}
