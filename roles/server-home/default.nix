{
  lib,
  config,
  ...
}:
{
  options.mine.server-home.enable = lib.mkEnableOption "'server-home' role";

  config.mine.server-home = lib.mkIf config.mine.server-home.enable {
    services = {
      fluidd.enable = true;
      habitsync.enable = true;
      vikunja.enable = true;
    };
  };
}
