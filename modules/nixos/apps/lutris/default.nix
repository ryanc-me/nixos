{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.lutris;
in
{
  options.mine.nixos.apps.lutris = {
    enable = mkEnableOption "lutris (game platform)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
