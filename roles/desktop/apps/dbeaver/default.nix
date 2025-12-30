{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.dbeaver;
in
{
  options.mine.desktop.apps.dbeaver = {
    enable = mkEnableOption "DBeaver (database management tool)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dbeaver-bin
    ];
  };
}
