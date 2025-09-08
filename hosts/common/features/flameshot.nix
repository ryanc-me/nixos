{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    #(flameshot.override { enableWlrSupport = true; })
    (pkgs.flameshot.overrideAttrs (old: {
      cmakeFlags = old.cmakeFlags or [ ] ++ [ "-DUSE_WAYLAND_GRIM=ON" ];
    }))
  ];
}
