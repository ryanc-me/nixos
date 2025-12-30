{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.bottles;
in
{
  options.mine.desktop.apps.bottles = {
    enable = mkEnableOption "Bottles (Windows compatibility layer)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
