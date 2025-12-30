{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.cli.ruff;
in
{
  options.mine.desktop.cli.ruff = {
    enable = mkEnableOption "Ruff (Python linter/formatter)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ruff
    ];
  };
}
