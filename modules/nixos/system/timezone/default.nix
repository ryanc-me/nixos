{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.nixos.system.timezone;
in

{
  options.mine.nixos.system.timezone = {
    enable = mkEnableOption "Enable setting the system timezone";
    location = mkOption types.str "Pacific/Auckland" "Timezone Location";
  };

  config = mkIf cfg.enable {
    time.timeZone = "${cfg.location}";
  };
}
