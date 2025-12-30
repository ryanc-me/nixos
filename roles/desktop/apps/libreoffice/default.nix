{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.libreoffice;
in
{
  options.mine.desktop.apps.libreoffice = {
    enable = mkEnableOption "LibreOffice (office suite)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt6
    ];
  };
}
