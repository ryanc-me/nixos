{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.cli.step-cli;
in
{
  options.mine.nixos.cli.step-cli = {
    enable = mkEnableOption "Enable Step CLI";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      step-cli
    ];
  };
}
