{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.anydesk;
in
{
  options.mine.desktop.apps.anydesk = {
    enable = mkEnableOption "Anydesk (remote desktop software)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      anydesk
    ];
  };
}
