{ config, pkgs, ... }:

{
  # force Electron apps to use wayland instead of xwayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
