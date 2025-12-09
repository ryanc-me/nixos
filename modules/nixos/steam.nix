{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
