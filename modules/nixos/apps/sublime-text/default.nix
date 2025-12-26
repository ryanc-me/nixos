{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.sublime-text;
in
{
  options.mine.nixos.apps.sublime-text = {
    enable = mkEnableOption "Enable Sublime Text 4 (text editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sublime4
    ];
  };
}
