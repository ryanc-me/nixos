{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.printer.services.camera-streamer;
in
{
  imports = [ ./camera-streamer.nix ];

  options.mine.printer.services.camera-streamer = {
    enable = mkEnableOption "camera-streamer";
  };

  config = mkIf cfg.enable {
    services.camera-streamer = {
      enable = true;
      interface = "0.0.0.0";
      extraArgs = [
        "--camera-path=/dev/video0"
        "--camera-format=JPEG"
        "--camera-width=1920"
        "--camera-height=1080"
        "--camera-fps=30"
        "--camera-nbufs=3"
        "--camera-video.disabled"
      ];
    };
  };
}
