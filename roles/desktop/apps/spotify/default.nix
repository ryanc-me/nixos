{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.spotify;
in
{
  options.mine.desktop.apps.spotify = {
    enable = mkEnableOption "Spotify (audio app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      spotify
    ];
  };
}
