{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.dbeaver;
in
{
  options.mine.nixos.apps.dbeaver = {
    enable = mkEnableOption "Enable DBeaver (database management tool)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dbeaver-bin
    ];
  };
}
