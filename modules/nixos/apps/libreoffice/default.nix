{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.libreoffice;
in
{
  options.mine.apps.libreoffice = {
    enable = mkEnableOption "Enable LibreOffice (office suite)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt6
    ];
  };
}
