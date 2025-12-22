{ config, pkgs, ... }:

{
  # note, these should be added to modules/home/gnome-extensions.nix too, to
  # ensure they're auto-activated
  #TODO: install via home-manager instead?
  environment.systemPackages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.just-perfection
    gnomeExtensions.caffeine
    gnomeExtensions.tailscale-qs
    gnomeExtensions.emoji-copy
    gnomeExtensions.iso-clock
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.color-picker
    gnomeExtensions.launch-new-instance
    gnomeExtensions.forge
    gnomeExtensions.status-area-horizontal-spacing
  ];
}
