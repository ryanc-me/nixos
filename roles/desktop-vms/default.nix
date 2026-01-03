{
  lib,
  config,
  ...
}:
{
  options.mine.desktop-vms.enable = lib.mkEnableOption "'desktop-vms' role";

  config.mine.desktop-vms = lib.mkIf config.mine.desktop-vms.enable {
    apps = {
      virt-manager.enable = true;
    };
    system = {
      libvirt.enable = true;
    };
  };
}
