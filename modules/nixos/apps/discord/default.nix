{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.discord;
in
{
  options.mine.nixos.apps.discord = {
    enable = mkEnableOption "discord (chat app)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
