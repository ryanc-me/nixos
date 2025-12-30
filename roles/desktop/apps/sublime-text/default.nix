{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.sublime-text;
in
{
  options.mine.desktop.apps.sublime-text = {
    enable = mkEnableOption "Sublime Text 4 (text editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sublime4
    ];
  };
}
