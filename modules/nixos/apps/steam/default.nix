{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.steam;
in
{
  options.mine.apps.steam = {
    enable = mkEnableOption "Enable Steam (gaming platform)";
    protonGE = {
      enable =
        mkEnableOption "Enable Proton-GE (custom version of Proton with additional patches and features)"
        // {
          default = true;
        };
    };
    mangohud = {
      enable = mkEnableOption "Enable MangoHud (performance overlay for games)" // {
        default = true;
      };
    };
    gamemode = {
      enable =
        mkEnableOption "Enable GameMode (Linux system daemon for optimizing performance of games)"
        // {
          default = true;
        };
    };
    gamescope = {
      enable =
        mkEnableOption "Enable Gamescope (micro-compositor for running games in a nested Wayland session)"
        // {
          default = true;
        };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      gamescope = {
        enable = cfg.gamescope.enable;
        capSysNice = false;
      };
      gamemode.enable = cfg.gamemode.enable;
      steam = {
        enable = true;
        gamescopeSession.enable = cfg.gamescope.enable;
        extraCompatPackages = mkIf cfg.protonGE.enable [ pkgs.proton-ge-bin ];
        package = mkIf cfg.gamemode.enable (pkgs.steam.override { extraPkgs = pkgs: [ pkgs.gamemode ]; });
      };
    };

    environment.systemPackages = mkIf cfg.mangohud.enable [
      pkgs.mangohud
    ];
  };
}
