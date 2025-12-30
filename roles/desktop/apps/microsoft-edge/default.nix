{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.microsoft-edge;
in
{
  options.mine.desktop.apps.microsoft-edge = {
    enable = mkEnableOption "Microsoft Edge (web browser)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      microsoft-edge
    ];
  };
}
