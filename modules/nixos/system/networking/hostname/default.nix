{
  lib,
  config,
  hostname,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.nixos.system.networking.hostname;
in
{
  options.mine.nixos.system.networking.hostname = {
    enable = mkEnableOption "Enable hostname configuration" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = hostname;
    };
  };
}
