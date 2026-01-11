{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-gaming.apps.gamma-launcher;
in
{
  options.mine.desktop-gaming.apps.gamma-launcher = {
    enable = mkEnableOption "gamma-launcher";
  };

  # https://github.com/Red007Master/Red-s-Guide-on-Installing-G.A.M.M.A.-on-Linux
  # https://github.com/Mord3rca/gamma-launcher
  # https://github.com/DravenusRex/stalker-gamma-linux-guide
  # https://gist.github.com/v1ld/e9069af307bd90495e0b345f3a260725
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gamma-launcher
    ];
  };
}
