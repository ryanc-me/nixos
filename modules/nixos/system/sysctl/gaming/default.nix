{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.nixos.system.sysctl.gaming;
in

{
  options.mine.nixos.system.sysctl.gaming = {
    enable = mkEnableOption "gaming-focused sysctls";
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      "vm.max_map_count" = 1048576;
    };
  };
}
