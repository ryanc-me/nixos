{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.toggl-track;
in
{
  options.mine.desktop.apps.toggl-track = {
    enable = mkEnableOption "Toggl Track (time tracking app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      toggl-track
    ];
  };
}
