{
  lib,
  config,
  ...
}:
{
  options.mine.server-media = {
    enable = lib.mkEnableOption "'server-media' role";

    domainBase = lib.mkOption {
      type = lib.types.str;
      description = "Base domain for media server services.";
    };
  };

  config.mine.server-media = lib.mkIf config.mine.server-media.enable {
    domainBase = "mixeto.io";

    services = {
      bazarr.enable = true;
      certs.enable = true;
      lidarr.enable = true;
      nginx.enable = true;
      overseerr.enable = true;
      plex.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
    };
  };
}
