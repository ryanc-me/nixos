{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.desktop-gaming.system.wine;
in

{
  options.mine.desktop-gaming.system.wine = {
    enable = mkEnableOption "gaming-focused wines";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineWow64Packages.stable
      winetricks
      zenity
      libadwaita
    ];
  };
}
