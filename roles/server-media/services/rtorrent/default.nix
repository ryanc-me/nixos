{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.rtorrent;
  nginx = config.mine.server-media.services.nginx;
in
{
  options.mine.server-media.services.rtorrent = {
    enable = mkEnableOption "rtorrent (TV shows)";
  };

  config = mkIf cfg.enable {
    services.rtorrent = {
      enable = true;
      dataDir = "/var/lib/rtorrent";
      downloadDir = "/mnt/torrent-data/torrents/other";
      dataPermissions = "0750";
      configText = ''
        system.daemon.set = true

        directory.default.set = (cat,"/mnt/torrent-data/torrents/other")
        session.path.set = (cat,"/var/lib/rtorrent/session/")

        # Throttling
        throttle.min_peers.normal.set = 99
        throttle.max_peers.normal.set = 200
        throttle.min_peers.seed.set = 99
        throttle.max_peers.seed.set = 100
        throttle.max_uploads.global.set = 300
        throttle.max_uploads.set = 50
        throttle.max_downloads.global.set = 300
        throttle.max_downloads.set = 50
        throttle.global_down.max_rate.set_kb = 0
        throttle.global_up.max_rate.set_kb = 0

        network.xmlrpc.size_limit.set = 4M
        network.max_open_sockets.set = 999
        network.max_open_files.set = 600
        network.http.max_open.set = 99

        trackers.numwant.set = 100

        pieces.memory.max.set = 4096M

        # Stop torrents when your drive has <100M free disk space
        schedule = low_diskspace,5,60,close_low_diskspace=100M

        # Downloading settings
        pieces.hash.on_completion.set = yes
        protocol.encryption.set = allow_incoming,try_outgoing,enable_retry

        # DHT / PEX settings
        dht.mode.set = auto
        protocol.pex.set = yes
        trackers.use_udp.set = yes

        encoding.add = utf8
        system.umask.set = 0022

        #schedule2 = watch_directory, 1, 1, (cat,"load.start=","/watch/","*.torrent")
        #schedule2 = untied_directory, 5, 5, (cat,"stop_untied=","/watch/","*.torrent")
        #schedule2 = watch_directory_1,5,5,(cat, "load.start=", "/watch/", "*.torrent")

        schedule2 = monitor_diskspace, 15, 60, ((close_low_diskspace,10000M))

        schedule2 = session_save, 1200, 43200, ((session.save))

        #schedule = watch_directory,1,5, "load.start=/watch/books/*.torrent,d.directory.set=/mnt/torrent-data/torrents/__books/,d.delete_tied=,d.custom1.set=books"

        # cross-seed
        #TODO: this
        # method.set_key=event.download.finished,cross_seed,"execute={'/data/rtorrent/rtorrent-cross-seed.sh',$d.hash=}"
      '';
    };

    users.users."rtorrent".extraGroups = [
      "media-tv"
      "media-movies"
      "media-music"
    ];

    #TODO: remove this
    # https://github.com/NixOS/nixpkgs/issues/445186
    systemd.services.rtorrent.serviceConfig.SystemCallFilter = ["@chown" ];

    users.users."rtorrent".extraGroups = [ "media-tv" ];
  };
}
