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
  config = mkIf osConfig.mine.nixos.apps.discord.enable {
    xdg.configFile."iscord/settings.json".text = ''
      {
        "SKIP_HOST_UPDATE": true
      }
    '';
  };
}
