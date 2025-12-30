{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.obsidian;
in
{
  options.mine.desktop.apps.obsidian = {
    enable = mkEnableOption "Obsidian (note-taking and knowledge management app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
