{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.blender;
in
{
  options.mine.apps.blender = {
    enable = mkEnableOption "Enable Blender (3D modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blender
    ];
  };
}
