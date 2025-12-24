{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.system.impermanence;
in
{
  options.mine.system.impermanence = {
    enable = mkEnableOption "Enable impermanence system";
  };

  config = mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/flatpak"

        "/etc/ssh"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };
}
