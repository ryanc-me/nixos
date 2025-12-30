{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.prusa-slicer;
in
{
  options.mine.desktop.apps.prusa-slicer = {
    enable = mkEnableOption "prusa-slicer (3d printer slicer)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prusa-slicer
    ];
  };
}
