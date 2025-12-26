{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.prusa-slicer;
in
{
  options.mine.nixos.apps.prusa-slicer = {
    enable = mkEnableOption "prusa-slicer (3d printer slicer)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prusa-slicer
    ];
  };
}
