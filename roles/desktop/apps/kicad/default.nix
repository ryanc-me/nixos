{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.kicad;
in
{
  options.mine.desktop.apps.kicad = {
    enable = mkEnableOption "kicad (electronic design automation software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kicad
    ];
  };
}
