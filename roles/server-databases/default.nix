{
  lib,
  config,
  ...
}:
{
  options.mine.server-databases = {
    enable = lib.mkEnableOption "'server-databases' role";
  };
  config.mine.server-databases = lib.mkIf config.mine.server-databases.enable {
    services = {
      mosquitto.enable = true;
      postgresql.enable = true;
    };
  };
}
