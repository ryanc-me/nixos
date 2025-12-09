{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./1password.nix
    ./boot.nix
    ./firewall.nix
    ./docker.nix
    ./electron-wayland.nix
    ./flatpaks.nix
    ./impermanence.nix
    ./obs-studio.nix
    ./sops.nix
    ./sshd.nix
    ./steam.nix
    ./users.nix
    ./utils.nix
    ./wallpaper.nix

    ./gnome
  ];
}
