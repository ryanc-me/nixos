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
  config = mkIf (osConfig.mine ? desktop && osConfig.mine.desktop.apps.alacritty.enable) {
    programs.alacritty = {
      enable = true;
    };
  };
}
