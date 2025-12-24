{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli.ruff;
in
{
  options.mine.cli.ruff = {
    enable = mkEnableOption "Enable Ruff (Python linter/formatter)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ruff
    ];
  };
}
