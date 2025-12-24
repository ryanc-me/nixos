{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.inkscape;
in
{
  options.mine.apps.inkscape = {
    enable = mkEnableOption "Enable Inkscape (vector graphics editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inkscape
    ];
  };
}
