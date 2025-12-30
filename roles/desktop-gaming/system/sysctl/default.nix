{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.desktop-gaming.system.sysctl;
in

{
  options.mine.desktop-gaming.system.sysctl = {
    enable = mkEnableOption "gaming-focused sysctls";
  };

  config = mkIf cfg.enable {
    # apparently helps with the 30-minute lag spikes in some games
    boot.kernel.sysctl = {
      "vm.max_map_count" = 1048576;
    };
  };
}
