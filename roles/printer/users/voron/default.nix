{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.printer.users.voron;
in
{
  options.mine.printer.users.voron = {
    enable = mkEnableOption "voron user";
  };

  config = mkIf cfg.enable {
    users = {
      users.voron = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."ryan/password".path;
        extraGroups = [
          "wheel"
        ];
      };
      users.ryan.extraGroups = [ "voron" ];
      groups.voron = { };
    };
  };
}
