{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-gaming.apps.steam;
in
{
  options.mine.desktop-gaming.apps.steam = {
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
    security.rtkit.enable = true;
    programs = {
      gamescope = {
        enable = cfg.gamescope.enable;
        capSysNice = false;
        env = {
          DXVK_ENABLE_NVAPI = "1";
          PROTON_ENABLE_NVAPI = "1";
          PROTON_HIDE_NVIDIA_GPU = "0";
          __GL_GSYNC_ALLOWED = "1";
          __GL_VRR_ALLOWED = "1";
          __GL_THREADED_OPTIMIZATIONS = "0";
          DXVK_ASYNC = "1";
        };
      };
      gamemode.enable = cfg.gamemode.enable;
      steam = {
        enable = true;
        gamescopeSession.enable = cfg.gamescope.enable;
        extraCompatPackages = mkIf cfg.protonGE.enable [ pkgs.proton-ge-bin ];
        package = pkgs.steam.override {
          # include manual packages, plus the gamemode ones
          extraPkgs =
            pkgs':
            lib.optionals (cfg.gamescope.enable) [
              pkgs'.libXcursor
              pkgs'.libXi
              pkgs'.libXinerama
              pkgs'.libXScrnSaver
              pkgs'.libpng
              pkgs'.libpulseaudio
              pkgs'.libvorbis
              pkgs'.stdenv.cc.cc.lib
              pkgs'.libkrb5
              pkgs'.keyutils
            ]
            ++ lib.optionals cfg.gamemode.enable [ pkgs'.gamemode ]
            ++ lib.optionals cfg.mangohud.enable [ pkgs'.mangohud ];
        };
        remotePlay.openFirewall = true;
      };
    };

    # networking.firewall = {
    #   allowedUDPPorts = [
    #     10400
    #     10401
    #   ];
    # };

    environment.systemPackages = mkIf cfg.mangohud.enable [
      pkgs.mangohud
    ];
  };
}
