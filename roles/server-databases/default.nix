{
  lib,
  config,
  ...
}:
{
  options.mine.server-databases = {
    enable = lib.mkEnableOption "'server-databases' role";
  };
  config.mine.server-matrix = lib.mkIf config.mine.server-databases.enable {
    services = {
      postgresql.enable = true;
    };
  };
}
