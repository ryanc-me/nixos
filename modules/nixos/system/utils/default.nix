{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf optional;
  cfg = config.mine.system.utils;

  cli-utils = with pkgs; [
    strace
    ltrace
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];
  text-editors = with pkgs; [
    nano
    vim
    neovim
  ];
  archiving-compression = with pkgs; [
    zip
    xz
    unzip
    p7zip
    zstd
    gnutar
    gzip
    pigz
    rar
  ];
  nix-utils = with pkgs; [
    nixfmt
    nix-output-monitor
  ];
  network-utils = with pkgs; [
    wget
    curl
    iperf3
    dnsutils
    socat
    nmap
  ];
  system-monitoring = with pkgs; [
    htop
    btop
    iotop
    iftop
    nethogs
    ncdu
  ];
  other-utils = with pkgs; [
    fastfetch
    cowsay
    file
    which
    tree
    gnused
    gawk
    gnupg
    age
    imagemagick
  ];
  system-tools = with pkgs; [
    strace
    ltrace
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];
in
{
  options.mine.system.utils = {
    enable = mkEnableOption "Enable core system utils";

    cli-utils = mkEnableOption "Enable CLI utilities";
    text-editors = mkEnableOption "Enable text editors";
    archiving-compression = mkEnableOption "Enable archiving and compression utilities";
    nix-utils = mkEnableOption "Enable Nix related utilities";
    network-utils = mkEnableOption "Enable network utilities";
    system-monitoring = mkEnableOption "Enable system monitoring utilities";
    other-utils = mkEnableOption "Enable miscellaneous utilities";
    system-tools = mkEnableOption "Enable system tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      [ ]
      ++ (optional cfg.cli-utils cli-utils)
      ++ (optional cfg.text-editors text-editors)
      ++ (optional cfg.archiving-compression archiving-compression)
      ++ (optional cfg.nix-utils nix-utils)
      ++ (optional cfg.network-utils network-utils)
      ++ (optional cfg.system-monitoring system-monitoring)
      ++ (optional cfg.other-utils other-utils)
      ++ (optional cfg.system-tools system-tools);
  };
}
