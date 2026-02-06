{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.services.flatpak;
  nixosCfg = osConfig.mine.desktop.services.flatpak;
in
{
  options.mine.home.services.flatpak = {
    enable = mkEnableOption "flatpak support";
  };

  config = mkIf (cfg.enable && nixosCfg.enable) {
    services.flatpak = {
      enable = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };
  };
}
