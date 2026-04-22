{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.printer.services.klipper;
in
{
  options.mine.printer.services.klipper = {
    enable = mkEnableOption "klipper service";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /home/voron/printer_data          0755 voron voron -"
      "d /home/voron/printer_data/config   0755 voron voron -"
      "d /home/voron/printer_data/logs     0755 voron voron -"
      "d /home/voron/printer_data/gcodes   0755 voron voron -"
      "d /home/voron/printer_data/database 0755 voron voron -"
    ];

    services.klipper = {
      enable = true;
      user = "voron";
      group = "voron";

      configDir = "/home/voron/printer_data/config";
      logFile = "/home/voron/printer_data/logs/klippy.log";

      # manage the config outside nix - this is much more tinker-friendly
      mutableConfig = true;
      settings = {
        printer = {
          kinematics = "corexy";
          max_velocity = 300;
          max_accel = 3000;
        };
      };

      firmwares.mcu = {
        enable = true;
        configFile = ./octopus-firmware.cfg;
        # enableKlipperFlash = true;
        # serial = "/dev/serial/by-id/usb-Klipper_stm32f446xx_120024001350565843333620-if00";
      };
    };
  };

  # building board firmware:

  # cd && git clone https://github.com/Klipper3d/klipper.git
  # nix shell \
  #   nixpkgs#git \
  #   nixpkgs#gnumake \
  #   nixpkgs#pkg-config \
  #   nixpkgs#ncurses \
  #   nixpkgs#gcc \
  #   nixpkgs#gcc-arm-embedded \
  #   nixpkgs#avrdude \
  #   nixpkgs#pkgsCross.avr.buildPackages.gcc \
  #   nixpkgs#dfu-util
  # cd ~/klipper
  # make clean
  # make menuconfig
  # make

  # options for the build:
  # - STMicroelectronics STM32
  # - STM32F446
  # - 32KiB bootloader
  # - 12 MHz
  # - USB
}
