{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.zed;
in
{
  options.mine.desktop.apps.zed = {
    enable = mkEnableOption "Zed (text editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      zed-editor
    ];
  };
}
