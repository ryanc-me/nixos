{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../roles
  ];
  
  mine = {
    core.services.sshd.port = 25091;

    # enable roles
    core.enable = true;
    users.enable = true;
    server-media.enable = true;
  };

  system.stateVersion = "25.05";
}
