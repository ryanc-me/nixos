{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.firefox;
in
{
  options.mine.nixos.apps.firefox = {
    enable = mkEnableOption "Enable Firefox (web browser)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
