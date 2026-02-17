{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.cli.direnv;
in
{
  options.mine.desktop.cli.direnv = {
    enable = mkEnableOption "direnv (automatic environment setup utility)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      direnv
    ];
  };
}
