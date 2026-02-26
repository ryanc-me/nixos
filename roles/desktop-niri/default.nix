{
  lib,
  config,
  ...
}:
{
  options.mine.desktop-niri.enable = lib.mkEnableOption "'desktop-niri' role";

  config.mine.desktop-niri = lib.mkIf config.mine.desktop-niri.enable {
    system = {
      awww.enable = true;
      niri.enable = true;
      noctalia.enable = true;
      power-profiles-daemon.enable = true;
      sddm.enable = true;
      upower.enable = true;
    };
  };
}
