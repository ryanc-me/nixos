{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.google-chrome;
in
{
  options.mine.nixos.apps.google-chrome = {
    enable = mkEnableOption "Enable Google Chrome (web browser)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      google-chrome
    ];
  };
}
