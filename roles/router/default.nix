{ lib, ... }:
let
  recursiveImportDefault = (import ../../lib/recursiveImportDefault.nix { inherit lib; }).recursiveImportDefault;
in
{
  imports = recursiveImportDefault ./.;

  # config.mine.router = {

  # };
}
