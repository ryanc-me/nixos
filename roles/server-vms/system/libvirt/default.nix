{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.server-vms.system.libvirt;
in
{
  options.mine.server-vms.system.libvirt = {
    enable = mkEnableOption "libvirtd";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [ "br0" ];
      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = with pkgs; [ virtiofsd ];
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    environment.systemPackages = with pkgs; [
      dnsmasq
    ];
  };
}
