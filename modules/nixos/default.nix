{ config, lib, pkgs, ... }:

{
  imports = [
    ./1password.nix
    ./boot.nix
    ./firewall.nix
    ./docker.nix
    ./electron-wayland.nix
    ./flatpaks.nix
    ./obs-studio.nix
    ./sops.nix
    ./sshd.nix
    ./users.nix
    ./utils.nix
    ./wallpaper.nix

    ./gnome
  ];
}
