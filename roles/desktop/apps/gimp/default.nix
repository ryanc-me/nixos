{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.gimp;
in
{
  options.mine.desktop.apps.gimp = {
    enable = mkEnableOption "GIMP (image editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp
    ];
  };
}
