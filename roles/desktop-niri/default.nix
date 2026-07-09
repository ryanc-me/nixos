{
  lib,
  config,
  ...
}:
{
  options.mine.desktop-niri.enable = lib.mkEnableOption "'desktop-niri' role";

  config = lib.mkIf config.mine.desktop-niri.enable {
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    mine.desktop-niri = {
      system = {
        awww.enable = true;
        niri.enable = true;
        noctalia.enable = true;
        playerctl.enable = true;
        power-profiles-daemon.enable = true;
        sddm.enable = false;
        upower.enable = true;
      };
    };
  };
}
