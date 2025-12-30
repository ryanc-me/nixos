{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.freecad;
in
{
  options.mine.desktop.apps.freecad = {
    enable = mkEnableOption "FreeCAD (3D CAD modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      freecad
    ];
  };
}
