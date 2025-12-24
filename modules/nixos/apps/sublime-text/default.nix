{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.sublime-text;
in
{
  options.mine.apps.sublime-text = {
    enable = mkEnableOption "Enable Sublime Text 4 (text editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sublime4
    ];
  };
}
