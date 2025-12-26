{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.gimp;
in
{
  options.mine.nixos.apps.gimp = {
    enable = mkEnableOption "Enable GIMP (image editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp
    ];
  };
}
