{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.cli.pangolin-cli;
in
{
  options.mine.desktop.cli.pangolin-cli = {
    enable = mkEnableOption "Step CLI";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pangolin-cli
    ];
  };
}
