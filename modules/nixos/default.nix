{ config, lib, pkgs, ... }:

{
  imports = [
    ./1password.nix
    ./boot.nix
    ./sops.nix
    ./users.nix
    ./electron-wayland.nix
    ./utils.nix
    ./1password.nix
    ./obs-studio.nix
    ./sshd.nix
    ./wallpaper.nix

    ./gnome
  ];
}
