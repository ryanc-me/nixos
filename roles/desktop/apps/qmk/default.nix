{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.qmk;
in
{
  options.mine.desktop.apps.qmk = {
    enable = mkEnableOption "qmk tools for mechanical keyboards";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # CLI tools
      qmk
      qmk_hid

      # adds some basic udev rules, from:
      # https://github.com/qmk/qmk_firmware/blob/master/util/udev/50-qmk.rules
      qmk-udev-rules
    ];

    services.udev.packages = [ pkgs.via ];

    # # for my Nuphy Air75 V2 + its DFU mode
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="19f5", ATTRS{idProduct}=="3246", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="users", TAG+="uaccess"
    '';

    # reload udev rules:
    # sudo udevadm control --reload-rules && sudo udevadm triggery

    # firmware update for Nuphy Air75 V2
    #
    # download the firmware .bin from:
    # https://nuphy.com/pages/qmk-firmwares
    #
    # 0. run `qmk setup`
    # 1. unplug keyboard
    # 2. hold ESC, plug back in (enables DFU mode)
    # 3. `qmk console` should show: `Ψ Bootloader Connected: stm32-dfu: STM32 BOOTLOADER`
    # 4.
  };
}
