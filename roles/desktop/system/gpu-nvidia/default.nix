{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop.system.gpu-nvidia;
in
{
  options.mine.desktop.system.gpu-nvidia = {
    enable = mkEnableOption "NVIDIA GPU support";
  };

  config = mkIf cfg.enable {
    # https://nixos.wiki/wiki/Nvidia
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          gamescope-wsi
          nvidia-vaapi-driver
          libvdpau-va-gl
          libva-vdpau-driver
        ];
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement = {
          enable = true;
          # finegrained = true;
        };
        open = true;
        nvidiaSettings = true;

        # stable driver
        package = config.boot.kernelPackages.nvidiaPackages.latest;

        # or, specific version
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "580.95.05";
        #   sha256_64bit = "sha256-hJ7w746EK5gGss3p8RwTA9VPGpp2lGfk5dlhsv4Rgqc=";
        #   sha256_aarch64 = "sha256-zLRCbpiik2fGDa+d80wqV3ZV1U1b4lRjzNQJsLLlICk=";
        #   openSha256 = "sha256-RFwDGQOi9jVngVONCOB5m/IYKZIeGEle7h0+0yGnBEI=";
        #   settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
        #   persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
        # };
      };
      opengl.enable = true;
    };

    environment.systemPackages = with pkgs; [
      nvtopPackages.nvidia
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    powerManagement.enable = true;

  };
}
