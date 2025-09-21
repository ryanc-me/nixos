{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  #TODO: move userspace apps into home-manager
  environment.systemPackages = with pkgs; [
    # programs
    kitty
    firefox
    calibre
    step-cli
    vscode
    sublime4
    obsidian
    inkscape
    gimp
    libreoffice-qt6
    vlc

    git-filter-repo

    # network tools
    wget
    curl

    # text editors
    nano
    vim
    neovim

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep
    jq
    yq-go
    eza
    fzf
    bat
    mtr
    iperf3
    dnsutils
    socat
    nmap
    stow
    nixfmt

    # misc
    fastfetch
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    age
    imagemagick

    # glib
    glib

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # system monitoring
    htop
    btop
    iotop
    iftop
    nethogs

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];
}
