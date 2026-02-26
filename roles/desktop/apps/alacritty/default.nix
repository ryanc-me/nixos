{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.alacritty;
in
{
  options.mine.desktop.apps.alacritty = {
    enable = mkEnableOption "alacritty (3D modeling software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alacritty
    ];
  };
}
