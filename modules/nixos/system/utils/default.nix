{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf optionals;
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
    nixfmt-tree
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
    eza
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

    cli-utils = mkEnableOption "Enable CLI utilities" // {
      default = true;
    };
    text-editors = mkEnableOption "Enable text editors" // {
      default = true;
    };
    archiving-compression = mkEnableOption "Enable archiving and compression utilities" // {
      default = true;
    };
    nix-utils = mkEnableOption "Enable Nix related utilities" // {
      default = true;
    };
    network-utils = mkEnableOption "Enable network utilities" // {
      default = true;
    };
    system-monitoring = mkEnableOption "Enable system monitoring utilities" // {
      default = true;
    };
    other-utils = mkEnableOption "Enable miscellaneous utilities" // {
      default = true;
    };
    system-tools = mkEnableOption "Enable system tools" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      [ ]
      ++ (optionals cfg.cli-utils cli-utils)
      ++ (optionals cfg.text-editors text-editors)
      ++ (optionals cfg.archiving-compression archiving-compression)
      ++ (optionals cfg.nix-utils nix-utils)
      ++ (optionals cfg.network-utils network-utils)
      ++ (optionals cfg.system-monitoring system-monitoring)
      ++ (optionals cfg.other-utils other-utils)
      ++ (optionals cfg.system-tools system-tools);
  };
}
