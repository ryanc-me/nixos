{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.nrf-connect;
in
{
  options.mine.desktop.apps.nrf-connect = {
    enable = mkEnableOption "nRF Connect (Nordic Semiconductor development tool)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nrfconnect
      nrfconnect-bluetooth-low-energy
    ];
    nixpkgs.config.segger-jlink.acceptLicense = true;
  };
}
