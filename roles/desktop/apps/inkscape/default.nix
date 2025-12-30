{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.inkscape;
in
{
  options.mine.desktop.apps.inkscape = {
    enable = mkEnableOption "Inkscape (vector graphics editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape
    ];
  };
}
