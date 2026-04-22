{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.mine.printer.enable = lib.mkEnableOption "'printer' role";

  config.mine.printer = lib.mkIf config.mine.printer.enable {
    services = {
      fluidd.enable = true;
      klipper.enable = true;
      mjpg-streamer.enable = true;
      moonraker.enable = true;
    };
    users = {
      voron.enable = true;
    };
  };
}
