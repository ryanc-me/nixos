{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  mkBtrfsDataDisk = uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "btrfs";
    options = [
      "noatime"
      "nodiratime"
      "space_cache=v2"
      "autodefrag"
      "nodatacow"
      "nofail"
    ];
  };

  mkExt4Disk = uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "ext4";
    options = [ "nofail" ];
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../roles
  ];
  
  mine = {
    core.services.sshd.port = 25091;

    # enable roles
    core.enable = true;
    users.enable = true;
    server-media.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mergerfs
    mergerfs-tools
  ];
  fileSystems = {
    # data disks
    "/mnt/disks/4TB-01" = mkBtrfsDataDisk "50995694-712f-4adc-b614-a31df94d90d0";
    "/mnt/disks/4TB-02" = mkBtrfsDataDisk "699cb5fa-f5eb-42b0-87d2-52e31aaaea44";
    "/mnt/disks/10TB-01" = mkBtrfsDataDisk "0feddc82-50aa-4807-bbbf-d9856d3aed5e";
    "/mnt/disks/10TB-02" = mkBtrfsDataDisk "22e34a34-8440-4703-8cc8-386099b76929";
    "/mnt/disks/10TB-03-parity" = mkExt4Disk "68b42458-608c-4a2a-bd23-05f68d9afc60";
    "/mnt/disks/10TB-04" = mkBtrfsDataDisk "1eba0130-c66d-40e7-a31b-7fe429b06762";

    "/mnt/disks/SSD-01" = mkExt4Disk "7cbc4902-783c-448f-a02c-6161de346f88";
    "/mnt/disks/SSD-02" = mkExt4Disk "d890228e-63a2-461e-a8a7-05049c9e557d";

    "/mnt/disks/old-nvme" = mkExt4Disk "0ffa4fb6-088e-4adc-bf96-05b211bb2ce4";

    # mergerfs
    "/mnt/raid-data" = {
      device = "/mnt/disks/4TB-01:/mnt/disks/4TB-02:/mnt/disks/10TB-01:/mnt/disks/10TB-02:/mnt/disks/10TB-04";
      fsType = "mergerfs";
      options = [
        "allow_other"
        "fsname=raid-data"
        "threads=6"
        "readahead=1024"
        "minfreespace=200G"
        "moveonenospc=true"
        "cache.statfs=30"
        "category.action=epall"
        "category.create=mspmfs"
        "category.search=ff"

      ];
    };
    "/mnt/torrent-data" = {
      device = "/mnt/disks/SSD-01:/mnt/disks/SSD-02";
      fsType = "mergerfs";
      options = [
        "allow_other"
        "fsname=raid-data"
        "threads=6"
        "moveonenospc=true"
        "minfreespace=50G"
        "category.action=epall"
        "category.create=epmfs"
        "category.search=ff"
      ];
    };
  };

  services.snapraid = {
    enable = true;
    dataDisks = {
      "4TB-01" = "/mnt/disks/4TB-01";
      "4TB-02" = "/mnt/disks/4TB-02";
      "10TB-01" = "/mnt/disks/10TB-01";
      "10TB-02" = "/mnt/disks/10TB-02";
      "10TB-04" = "/mnt/disks/10TB-04";
    };
    contentFiles = [
      "/mnt/snapraid.content"
      "/mnt/disks/4TB-01/snapraid.content"
      "/mnt/disks/4TB-02/snapraid.content"
      "/mnt/disks/10TB-01/snapraid.content"
      "/mnt/disks/10TB-02/snapraid.content"
      "/mnt/disks/10TB-04/snapraid.content"
    ];
    parityFiles = [
      "/mnt/disks/10TB-03-parity/snapraid.parity"
    ];
  };

  system.stateVersion = "25.05";
}
