{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.element;
in
{
  options.mine.nixos.apps.element = {
    enable = mkEnableOption "Enable Element (chat application for Matrix protocol)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      element-desktop
    ];
  };
}
