{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.core.services.vscode-server;
in
{
  options.mine.core.services.vscode-server = {
    enable = mkEnableOption "VSCode Server";
  };

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;

    # then, for any users who will be connected-to via VSCode:
    # systemctl --user enable --now auto-fix-vscode-server.service
  };
}
