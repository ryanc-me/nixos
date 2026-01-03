{
  lib,
  config,
  ...
}:
{
  options.mine.server-backups.enable = lib.mkEnableOption "'server-backups' role";

  config.mine.server-backups = lib.mkIf config.mine.server-backups.enable {

  };
}
