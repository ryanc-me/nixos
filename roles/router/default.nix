{
  lib,
  config,
  ...
}:
{
  options.mine.router.enable = lib.mkEnableOption "'router' role";

  config.mine.router = lib.mkIf config.mine.router.enable {

  };
}
