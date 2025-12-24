{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.cli.git;
in
{
  options.mine.cli.git = {
    enable = mkEnableOption "Enable Git";
  };

  config = mkIf cfg.enable {
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [
      git-filter-repo
    ];
  };
}
