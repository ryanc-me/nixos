{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-databases.services.postgresql;
  nginx = config.mine.server-nginx.services.nginx;

in
{
  options.mine.server-databases.services.postgresql = {
    enable = mkEnableOption "postgresql service";
    version = lib.mkOption {
      description = "PostgreSQL version";
      default = "18";
      type = lib.types.str;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowBroken = true;
    services.postgresql = {
      enable = true;
      package = pkgs."postgresql_${config.mine.server-databases.services.postgresql.version}";
      settings = {
        # WARNING
        # wal_compression = lz4 requires PostgreSQL
        # to be compiled with --with-lz4
        #
        # io_method = io_uring requires PostgreSQL
        # to be compiled with --with-liburing

        # DB Version: 18
        # OS Type: linux
        # DB Type: web
        # Total Memory (RAM): 8 GB
        # CPUs num: 8
        # Connections num: 256
        # Data Storage: ssd

        max_connections = 256;
        shared_buffers = "2GB";
        effective_cache_size = "6GB";
        maintenance_work_mem = "512MB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = "1.1";
        effective_io_concurrency = 200;
        work_mem = "10325kB";
        huge_pages = "try";
        jit = "off";
        wal_compression = "lz4";
        io_method = "io_uring";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 8;
        max_parallel_workers_per_gather = 4;
        max_parallel_workers = 8;
        max_parallel_maintenance_workers = 4;
      };

      authentication = ''
        #type   database    DBuser      auth-method   optional_ident_map
        local   all         postgres    peer
        local   sameuser    all         peer
      '';
    };

    environment.systemPackages = [
      pkgs."postgresql_${config.mine.server-databases.services.postgresql.version}"
    ];
  };
}
