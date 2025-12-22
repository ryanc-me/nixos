{ config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/Nvidia

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  powerManagement.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      # finegrained = true;
    };
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "580.95.05";
    #   sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
    #   sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
    #   openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
    #   settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
    #   persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
    # };
  };
}
