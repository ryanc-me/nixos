{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.users.ryan;
in
{
  options.mine.users.ryan = {
    enable = mkEnableOption "Enable user ryan";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "ryan/password" = {
        sopsFile = ../../../secrets/users.yaml;
        neededForUsers = true;
      };
    };

    users = {
      mutableUsers = false;
      users = {
        ryan = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."ryan/password".path;
          extraGroups = [
            "wheel"
          ]
          ++ lib.optionals config.mine.desktop-vms.system.libvirt.enable [ "libvirtd" ];
        };
      };
    };
  };
}
