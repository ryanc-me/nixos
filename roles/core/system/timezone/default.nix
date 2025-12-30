{ lib, config, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.mine.core.system.timezone;
in

{
  options.mine.core.system.timezone = {
    enable = mkEnableOption "timezone configuration";
    location = mkOption {
      type = types.str;
      default = "Pacific/Auckland";
      description = "Timezone Location";
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = "${cfg.location}";
  };
}
