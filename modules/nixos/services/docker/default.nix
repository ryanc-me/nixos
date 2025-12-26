{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.nixos.services.docker;
in
{
  options.mine.nixos.services.docker = {
    enable = mkEnableOption "Enable docker service";
    rootless = mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable rootless docker for users.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = mkIf cfg.rootless {
      # rootless only
      enable = false;
      rootless = {
        enable = true;
        # setting DOCKER_HOST precludes the use of docker contexts, which
        # are required for Wedoo's docker-dev setup
        #TODO: auto-crete docker context for local/rootless?
        setSocketVariable = false;
      };
    };
  };
}
