{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.core.system.boot-systemd;
in
{
  options.mine.core.system.boot-systemd = {
    enable = mkEnableOption "Systemd bootloader";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "auto";
      efi.canTouchEfiVariables = true;
    };
  };
}
