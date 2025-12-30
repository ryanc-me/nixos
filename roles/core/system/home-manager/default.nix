{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.core.system.home-manager;
in

{
  # OS-level options for home-manager (generally metadata - which users are active, etc)
  options.mine.core.system.home-manager = {
    enable = mkEnableOption "Home Manager";
  };

  # this is actually used in flake.nix
}
