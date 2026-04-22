{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.printer.services.moonraker;
in
{
  options.mine.printer.services.moonraker = {
    enable = mkEnableOption "moonraker service";
  };

  config = mkIf cfg.enable {
    # for allowSystemControl support below
    security.polkit.enable = true;

    services.moonraker = {
      enable = true;
      user = "voron";
      group = "voron";
      address = "127.0.0.1";
      port = 7125;
      stateDir = "/home/voron/printer_data";
      allowSystemControl = true;

      settings = {
        history = { };
        authorization = {
          trusted_clients = [
            "127.0.0.1"
            "::1/128"
          ];
          cors_domains = [
            "tier.lan"
            "fluidd.mixeto.io"
            "auth.mixeto.io"
          ];
        };
      };
    };
  };
}
