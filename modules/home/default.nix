{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./bash.nix
    ./docker-forwarding.nix
    ./electron-wayland.nix
    ./flatpaks.nix
    ./gnome-extensions.nix
    ./gnome-wallpaper.nix
    ./screenshot.nix
    ./syncthing.nix

    ./pwa
  ];
}
