{ config, pkgs, ... }:

{
  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/com.spotify.Client//stable"
      "flathub:app/io.gitlab.adhami3310.Impression//stable"
    ];
  };
}