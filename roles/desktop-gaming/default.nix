{ lib, ... }:
let
  recursiveImportDefault = (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  config.mine.desktop-gaming = {
    apps = {
      lutris.enable = true;
      steam.enable = true;
    };
    system = {
      sysctl.enable = true;
    };
  };
}
