{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.core.system.vscode-server;
in
{
  options.mine.core.system.vscode-server = {
    enable = mkEnableOption "VSCode Server";
  };

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;

    # then, for any users who will be connected-to via VSCode:
    # systemctl --user enable --now auto-fix-vscode-server.service
  };
}
