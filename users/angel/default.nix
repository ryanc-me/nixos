{
  config,
  pkgs,
  ...
}:

{
  home.username = "angel";
  home.homeDirectory = "/home/${config.home.username}";

  home.stateVersion = "25.05";
}
