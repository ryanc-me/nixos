{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../../modules/home

    ./dconf.nix
  ];

  home.username = "ryan";
  home.homeDirectory = "/home/${config.home.username}";

  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  fonts.fontconfig.enable = true;

  #TODO: fonts.nix
  #TODO: applications.nix
  home.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    satdump
  ];

  #TODO: theme.nix (or theme/default.nix, theme/fonts.nix, etc?)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # enable git
  services.ssh-agent.enable = true;

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Ryan Cole";
    userEmail = "admin@ryanc.me";
  };

  home.stateVersion = "25.05";
}
