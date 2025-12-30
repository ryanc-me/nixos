{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.cli.step-cli;
in
{
  options.mine.desktop.cli.step-cli = {
    enable = mkEnableOption "Step CLI";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      step-cli
    ];
  };
}
