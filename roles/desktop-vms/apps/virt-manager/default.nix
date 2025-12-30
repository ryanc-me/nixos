{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-vms.apps.virt-manager;
in
{
  options.mine.desktop-vms.apps.virt-manager = {
    enable = mkEnableOption "Virt Manager (virtual machine manager)";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
  };
}
