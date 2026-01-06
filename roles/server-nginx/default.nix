{
  lib,
  config,
  ...
}:
{
  options.mine.server-nginx = {
    enable = lib.mkEnableOption "'server-nginx' role";

    domainBase = lib.mkOption {
      type = lib.types.str;
      description = "Base domain for media server services.";
    };
  };
  config.mine.server-nginx = lib.mkIf config.mine.server-nginx.enable {
    domainBase = "mixeto.io";

    services = {
      certs.enable = true;
      default.enable = true;
      nginx.enable = true;
      oauth2-proxy.enable = true;
    };
  };
}
