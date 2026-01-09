{
  lib,
  config,
  ...
}:
{
  options.mine.server-matrix = {
    enable = lib.mkEnableOption "'server-matrix' role";
  };
  config.mine.server-matrix = lib.mkIf config.mine.server-matrix.enable {
    services = {
      continuwuity.enable = true;
    };
  };
}
