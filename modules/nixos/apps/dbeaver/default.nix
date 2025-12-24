{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.dbeaver;
in
{
  options.mine.apps.dbeaver = {
    enable = mkEnableOption "Enable DBeaver (database management tool)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dbeaver-bin
    ];
  };
}
