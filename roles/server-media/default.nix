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

  config.users = lib.mkIf config.mine.server-media.enable {
    groups = {
      "media-movies" = {
        gid = 3501;
        name = "media-movies";
      };
      "media-tv" = {
        gid = 3502;
        name = "media-tv";
      };
      "media-music" = {
        gid = 3503;
        name = "media-music";
      };
      "rtorrent-data" = {
        gid = 3601;
        name = "torrent-data";
      };
    };
  };
  config.mine.server-media = lib.mkIf config.mine.server-media.enable {
    domainBase = "mixeto.io";

    services = {
      bazarr.enable = true;
      certs.enable = true;
      default.enable = true;
      lidarr.enable = true;
      nginx.enable = true;
      oauth2-proxy.enable = true;
      overseerr.enable = true;
      plex.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      rtorrent.enable = true;
      rutorrent.enable = true;
      sonarr.enable = true;
      tautulli.enable = true;
    };
  };
}
