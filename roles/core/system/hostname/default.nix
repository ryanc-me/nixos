{
  lib,
  config,
  hostname,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.core.system.hostname;
in
{
  options.mine.core.system.hostname = {
    enable = mkEnableOption "Hostname configuration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = hostname;
    };
  };
}
