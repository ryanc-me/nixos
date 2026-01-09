{
  lib,
  config,
  ...
}:
{
  options.mine.server-immich = {
    enable = lib.mkEnableOption "'server-immich' role";
  };
  config.mine.server-immich = lib.mkIf config.mine.server-immich.enable {
    services = {
      immich.enable = true;
    };
  };
}
