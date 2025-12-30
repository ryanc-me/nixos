{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop.services.docker;
in
{
  options.mine.desktop.services.docker = {
    enable = mkEnableOption "Docker (for Desktop)";
    rootless = mkOption {
      type = lib.types.bool;
      description = "Enable rootless docker for users.";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker = mkIf cfg.rootless {
      # rootless only
      enable = false;
      rootless = {
        enable = true;

        # setting DOCKER_HOST precludes the use of docker contexts, which will not
        # work for me, so we opt to create a context for rootless docker instead
        #TODO: auto-crete docker context for local/rootless?
        setSocketVariable = false;
      };
    };
  };
}
