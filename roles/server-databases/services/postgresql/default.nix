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
