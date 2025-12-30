{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.google-chrome;
in
{
  options.mine.desktop.apps.google-chrome = {
    enable = mkEnableOption "Google Chrome (web browser)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      google-chrome
    ];
  };
}
