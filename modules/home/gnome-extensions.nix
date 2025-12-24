{ config, pkgs, ... }:

{
  dconf.settings."org/gnome/shell".enabled-extensions = [
    pkgs.gnomeExtensions.blur-my-shell.extensionUuid
    pkgs.gnomeExtensions.just-perfection.extensionUuid
    pkgs.gnomeExtensions.caffeine.extensionUuid
    pkgs.gnomeExtensions.tailscale-qs.extensionUuid
    pkgs.gnomeExtensions.emoji-copy.extensionUuid
    pkgs.gnomeExtensions.iso-clock.extensionUuid
    pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
    pkgs.gnomeExtensions.color-picker.extensionUuid
    pkgs.gnomeExtensions.launch-new-instance.extensionUuid
    pkgs.gnomeExtensions.forge.extensionUuid
    pkgs.gnomeExtensions.status-area-horizontal-spacing.extensionUuid
    pkgs.gnomeExtensions.appindicator.extensionUuid
  ];
}
