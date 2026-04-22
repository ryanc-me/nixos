{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.printer.services.mjpg-streamer;
in
{
  options.mine.printer.services.mjpg-streamer = {
    enable = mkEnableOption "mjpg-streamer";
  };

  config = mkIf cfg.enable {
    services.mjpg-streamer = {
      enable = true;
      inputPlugin = "input_uvc.so -d /dev/video0 -r 1920x1080 -q 80";
      outputPlugin = "output_http.so -w @www@ -n -p 5050";
    };
  };
}
