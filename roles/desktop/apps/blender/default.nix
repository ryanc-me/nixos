{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.blender;
in
{
  options.mine.desktop.apps.blender = {
    enable = mkEnableOption "Blender (3D modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blender
    ];
  };
}
