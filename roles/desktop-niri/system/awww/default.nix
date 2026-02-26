{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.awww;
  wp =
    config.mine.desktop.system.wallpaper.processed.plain.${config.mine.desktop.system.wallpaper.mode};
in
{
  options.mine.desktop-niri.system.awww = {
    enable = mkEnableOption "awww support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    ];
  };
}
