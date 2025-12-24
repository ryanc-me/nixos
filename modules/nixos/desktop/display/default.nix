{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption;
in
{
  options.mine.desktop.display = {
    screenW = lib.mkOption {
      type = lib.types.ints.positive;
      default = 3840;
      description = "The (primary) screen width, in pixels";
    };
    screenH = lib.mkOption {
      type = lib.types.ints.positive;
      default = 2160;
      description = "The (primary) screen height, in pixels";
    };
    screenScale = lib.mkOption {
      type = lib.types.float;
      default = 1.25;
      description = "The (primary) screen scale, as a float";
    };
  };
}
