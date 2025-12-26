{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.cli.ruff;
in
{
  options.mine.nixos.cli.ruff = {
    enable = mkEnableOption "Enable Ruff (Python linter/formatter)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ruff
    ];
  };
}
