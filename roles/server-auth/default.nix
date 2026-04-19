{
  lib,
  config,
  ...
}:
{
  options.mine.server-auth = {
    enable = lib.mkEnableOption "'server-auth' role";
  };
  config.mine.server-auth = lib.mkIf config.mine.server-auth.enable {
    services = {
      authentik.enable = true;
    };
  };
}
