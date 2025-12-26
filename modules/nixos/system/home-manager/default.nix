{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.system.home-manager;
in

{
  # OS-level options for home-manager (generally metadata - which users are active, etc)
  options.mine.system.home-manager = {
    enable = mkEnableOption "home-manager";
    enabledUsers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of enabled users on the system (leave empty to enable *all* in ./users)";
    };
    disabledUsers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of disabled users on the system (overrides enabledUsers)";
    };
  };

  # this is actually used in flake.nix
}
