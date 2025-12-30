{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.microsoft-teams;
in
{
  options.mine.desktop.apps.microsoft-teams = {
    enable = mkEnableOption "Microsoft Teams (communication app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      microsoft-teams
    ];
  };
}
