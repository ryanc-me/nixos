{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.firefox;
in
{
  options.mine.apps.firefox = {
    enable = mkEnableOption "Enable Firefox (web browser)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
