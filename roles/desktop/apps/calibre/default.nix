{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.calibre;
in
{
  options.mine.desktop.apps.calibre = {
    enable = mkEnableOption "Calibre (e-book manager)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      calibre
    ];
  };
}
