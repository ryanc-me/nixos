{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.superslicer;
in
{
  options.mine.desktop.apps.superslicer = {
    enable = mkEnableOption "superslicer (3D printing slicer)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      super-slicer-beta
    ];
  };
}
