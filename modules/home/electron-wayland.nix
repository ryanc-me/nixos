{ config, pkgs, ... }:

{
  # force Electron apps to use wayland instead of xwayland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';
}
