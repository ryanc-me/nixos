{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-gaming.apps.gamma-launcher;
in
{
  options.mine.desktop-gaming.apps.gamma-launcher = {
    enable = mkEnableOption "gamma-launcher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gamma-launcher
    ];
  };
}
