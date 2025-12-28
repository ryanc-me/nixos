{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.bottles;
in
{
  options.mine.nixos.apps.bottles = {
    enable = mkEnableOption "bottles (Windows compatibility layer)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bottles
    ];
  };
}
