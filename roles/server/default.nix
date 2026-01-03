{
  lib,
  config,
  ...
}:
{
  options.mine.server.enable = lib.mkEnableOption "'server' role";

  config.mine.server = lib.mkIf config.mine.server.enable {

  };
}
