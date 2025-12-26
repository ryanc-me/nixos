{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.microsoft-edge;
in
{
  options.mine.nixos.apps.microsoft-edge = {
    enable = mkEnableOption "Enable Microsoft Edge (web browser)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      microsoft-edge
    ];
  };
}
