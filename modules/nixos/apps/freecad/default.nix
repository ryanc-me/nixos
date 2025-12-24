{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.freecad;
in
{
  options.mine.apps.freecad = {
    enable = mkEnableOption "Enable FreeCAD (3D CAD modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      freecad
    ];
  };
}
