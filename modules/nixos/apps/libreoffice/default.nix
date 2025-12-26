{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.libreoffice;
in
{
  options.mine.nixos.apps.libreoffice = {
    enable = mkEnableOption "Enable LibreOffice (office suite)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt6
    ];
  };
}
