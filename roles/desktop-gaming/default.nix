{
  lib,
  config,
  ...
}:
{
  options.mine.desktop-gaming.enable = lib.mkEnableOption "'desktop-gaming' role";

  config.mine.desktop-gaming = lib.mkIf config.mine.desktop-gaming.enable {
    apps = {
      gamma-launcher.enable = true;
      lutris.enable = true;
      steam.enable = true;
    };
    system = {
      sysctl.enable = true;
    };
  };
}
