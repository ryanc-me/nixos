{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.system.boot.systemd;
in
{
  options.mine.system.boot.systemd = {
    enable = mkEnableOption "Enable systemd bootloader";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "auto";
      efi.canTouchEfiVariables = true;
    };
  };
}
