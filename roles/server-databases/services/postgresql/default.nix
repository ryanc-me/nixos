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
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_18;
    };
  };
}
