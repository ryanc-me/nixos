{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.element;
in
{
  options.mine.desktop.apps.element = {
    enable = mkEnableOption "Element (chat application for Matrix protocol)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      element-desktop
    ];
  };
}
