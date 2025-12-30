{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.system.boot-systemd;
in
{
  options.mine.desktop.system.boot-systemd = {
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
