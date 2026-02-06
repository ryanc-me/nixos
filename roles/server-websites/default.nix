{
  lib,
  config,
  ...
}:
{
  options.mine.server-websites = {
    enable = lib.mkEnableOption "'server-websites' role";
  };
  config.mine.server-websites = lib.mkIf config.mine.server-websites.enable {
    services = {
      ghost.enable = true;
    };
    sites = {
      ryanc-me.enable = true;
    };
  };
}
