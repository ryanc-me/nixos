{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.calibre;
in
{
  options.mine.nixos.apps.calibre = {
    enable = mkEnableOption "Enable Calibre (e-book manager)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      calibre
    ];
  };
}
