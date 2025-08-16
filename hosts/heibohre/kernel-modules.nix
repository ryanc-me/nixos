{ config, lib, pkgs, pkgs-unstable, ... }:

{
  # required to get the keyboard working during boot for LUKS decryption
  # note that the order *is* important!
  boot.initrd.availableKernelModules = [
    "pinctrl_icelake"
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_hid_core"
    "8250_dw"
    "surface_hid"
    "intel_lpss"
    "intel_lpss_pci"
  ];
}
