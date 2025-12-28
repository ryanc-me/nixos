{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.nixos.system.libvirt;
in
{
  options.mine.nixos.system.libvirt = {
    enable = mkEnableOption "libvirt";
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
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
