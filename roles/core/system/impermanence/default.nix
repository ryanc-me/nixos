{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.core.system.impermanence;
in
{
  options.mine.core.system.impermanence = {
    enable = mkEnableOption "Impermanence";
  };

  config = mkIf cfg.enable {
    #TODO: script to switch subvol on boot (i.e.: make this actually impermanent)
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
