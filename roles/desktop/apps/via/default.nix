{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.via;
in
{
  options.mine.desktop.apps.via = {
    enable = mkEnableOption "Via (PWA launcher)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      via
    ];
  };
}
