{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.system.users.ryan;
in
{
  options.mine.system.users.ryan = {
    enable = mkEnableOption "Enable user ryan";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "ryan/password" = {
        sopsFile = ../../secrets/users.yaml;
        neededForUsers = true;
      };
    };

    users = {
      mutableUsers = false;
      users = {
        ryan = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."ryan/password".path;
          extraGroups = [ "wheel" ];
        };
      };
    };
  };
}
