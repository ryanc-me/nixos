{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.gimp;
in
{
  options.mine.apps.gimp = {
    enable = mkEnableOption "Enable GIMP (image editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp
    ];
  };
}
