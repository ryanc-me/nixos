{
  lib,
  config,
  ...
}:
{
  options.mine.server-vms.enable = lib.mkEnableOption "'server-vms' role";

  config.mine.server-vms = lib.mkIf config.mine.server-vms.enable {
    system = {
      libvirt.enable = true;
    };
  };
}
