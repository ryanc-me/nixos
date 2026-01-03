{
  lib,
  config,
  ...
}:
{
  options.mine.monitoring-server.enable = lib.mkEnableOption "'monitoring-server' role";

  config.mine.monitoring-server = lib.mkIf config.mine.monitoring-server.enable {

  };
}
