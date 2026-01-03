{
  lib,
  config,
  ...
}:
{
  options.mine.monitoring.enable = lib.mkEnableOption "'monitoring' role";

  config.mine.monitoring = lib.mkIf config.mine.monitoring.enable {

  };
}
