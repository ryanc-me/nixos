{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.lite-xl;
in
{
  options.mine.desktop.apps.lite-xl = {
    enable = mkEnableOption "Lite XL (lightweight text editor)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lite-xl
    ];
  };
}
