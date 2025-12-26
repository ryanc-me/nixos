{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.blender;
in
{
  options.mine.nixos.apps.blender = {
    enable = mkEnableOption "Enable Blender (3D modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blender
    ];
  };
}
