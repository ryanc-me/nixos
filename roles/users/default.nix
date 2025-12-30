{ lib, ... }:
let
  recursiveImportDefault =
    (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  config.mine.users = {
    ryan.enable = lib.mkDefault true;
    angel.enable = lib.mkDefault false;
  };
}
