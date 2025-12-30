{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.vscode;
in
{
  options.mine.desktop.apps.vscode = {
    enable = mkEnableOption "Visual Studio Code (source code editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscode
    ];
  };
}
