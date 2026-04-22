{
  config,
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-3
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../../roles
  ];

  mine = {
    core = {
      cli = {
        git.enable = true;
      };
      services = {
        sshd.enable = true;
      };
      system = {
        hostname.enable = true;
        network-firewall.enable = true;
        timezone.enable = true;
        utils.enable = true;
      };
    };
    printer.enable = true;
    users.enable = true;
  };

  # since we will not be syncing authorized_keys from idir/aquime
  users.users.ryan.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKP3tTOgblS6r8RtvIJ2joqm8arsX/Rxa0qnu3BSpeze ryan-master"
  ];

  # because we aren't using impermanence
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # other misc tuning
  powerManagement.cpuFreqGovernor = "performance";

  networking.wireless = {
    enable = true;
  };
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  # to build the image:
  # $ zstd -dc /home/ryan/nixos/result/sd-image/nixos-image-sd-card-26.05.20260414.4bd9165-aarch64-linux.img.zst | sudo dd of=/dev/sda bs=4M conv=fsync status=progress

  system.stateVersion = "25.05";
}
