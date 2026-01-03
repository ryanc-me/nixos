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
  config = mkIf (osConfig.mine ? desktop && osConfig.mine.desktop.apps.discord.enable) {
    xdg.configFile."discord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
  };
}
