{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.freecad;
in
{
  options.mine.nixos.apps.freecad = {
    enable = mkEnableOption "Enable FreeCAD (3D CAD modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      freecad
    ];
  };
}
