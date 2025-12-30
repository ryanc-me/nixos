{ lib, ... }:
let
  recursiveImportDefault = (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  config.mine.desktop-vms = {
    apps = {
      virt-manager.enable = true;
    };
    system = {
      libvirt.enable = true;
    };
  };
}
