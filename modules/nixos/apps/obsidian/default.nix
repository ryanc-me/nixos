{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.obsidian;
in
{
  options.mine.nixos.apps.obsidian = {
    enable = mkEnableOption "Enable Obsidian (note-taking and knowledge management app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
