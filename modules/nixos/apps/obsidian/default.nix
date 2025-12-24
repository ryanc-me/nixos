{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.obsidian;
in
{
  options.mine.apps.obsidian = {
    enable = mkEnableOption "Enable Obsidian (note-taking and knowledge management app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
