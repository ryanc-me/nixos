{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.nixos.apps.virt-manager;
in
{
  options.mine.nixos.apps.virt-manager = {
    enable = mkEnableOption "Virt Manager (virtual machine manager)";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
  };
}
