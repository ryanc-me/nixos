{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.unpackerr;
  nginx = config.mine.server-media.services.nginx;
in
{
  imports = [ ./unpackerr.nix ];

  options.mine.server-media.services.unpackerr = {
    enable = mkEnableOption "unpackerr (archive extraction daemon)";
  };

  config = mkIf cfg.enable {
    sops.secrets."unpackerr" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/unpackerr.env;
      key = "";
    };

    services.unpackerr = {
      enable = true;
      environmentFile = config.sops.secrets."unpackerr".path;
    };

    users.users."unpackerr".extraGroups = ["torrent-data" "usenet-data" ];
  };
}
