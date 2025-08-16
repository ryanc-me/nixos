{ config, pkgs, ... }:

{
  sops.secrets = {
    "ryan/password" = {
      sopsFile = ../../secrets/users.yaml;
      neededForUsers = true;
    };
    "angel/password" = {
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
      angel = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."angel/password".path;
        extraGroups = [ "wheel" ];
      };
    };
  };
}
