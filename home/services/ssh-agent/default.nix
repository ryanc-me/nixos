{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.services.ssh-agent;
in
{
  options.mine.home.services.ssh-agent = {
    enable = mkEnableOption "ssh-agent";
  };

  config = mkIf cfg.enable {
    services.ssh-agent.enable = true;
  };
}
