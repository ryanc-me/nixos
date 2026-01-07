{
  lib,
  config,
  ...
}:
{
  options.mine.server-media.enable = lib.mkEnableOption "'server-media' role";

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
      "media-books" = {
        gid = 3504;
        name = "media-books";
      };
      "rtorrent-data" = {
        gid = 3601;
        name = "torrent-data";
      };
      "usenet-data" = {
        gid = 3602;
        name = "usenet-data";
      };
    };

    users."ryan".extraGroups = lib.optionals config.mine.users.ryan.enable [
      "media-movies"
      "media-tv"
      "media-music"
      "media-books"
      "torrent-data"
      "usenet-data"
    ];
  };
  config.mine.server-media = lib.mkIf config.mine.server-media.enable {
    services = {
      bazarr.enable = true;
      lidarr.enable = true;
      nzbhydra2.enable = true;
      sabnzbd.enable = true;
      overseerr.enable = true;
      plex.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      rtorrent.enable = true;
      rutorrent.enable = true;
      sonarr.enable = true;
      tautulli.enable = true;
      unpackerr.enable = true;
    };
  };
}
