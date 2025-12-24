{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.vscode;
in
{
  options.mine.apps.vscode = {
    enable = mkEnableOption "Enable Visual Studio Code (source code editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscode
    ];
  };
}
