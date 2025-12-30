{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.core.cli.git;
in
{
  options.mine.core.cli.git = {
    enable = mkEnableOption "Git CLI (with git-filter-repo)";
  };

  config = mkIf cfg.enable {
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [
      git-filter-repo
    ];
  };
}
