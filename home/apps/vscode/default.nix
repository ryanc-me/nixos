{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkIf;
in
{
  config = mkIf (osConfig.mine ? desktop && osConfig.mine.desktop.apps.vscode.enable) {
    programs.vscode = {
      enable = true;
      profiles."default" = {
        userSettings = lib.mkForce { };
      };
    };
  };
}
