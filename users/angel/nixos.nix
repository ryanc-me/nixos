{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.nixos.system.users.angel;
in
{
  options.mine.nixos.system.users.angel = {
    enable = mkEnableOption "Enable user angel";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "angel/password" = {
        sopsFile = ../../secrets/users.yaml;
        neededForUsers = true;
      };
    };

    users = {
      mutableUsers = false;
      users = {
        angel = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."angel/password".path;
        };
      };
    };
  };
}
