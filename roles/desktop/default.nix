{
  lib,
  config,
  ...
}:
{
  options.mine.desktop.enable = lib.mkEnableOption "'desktop' role";

  config.mine.desktop = lib.mkIf config.mine.desktop.enable {
    apps = {
      onepassword.enable = true;
      blender.enable = true;
      bottles.enable = true;
      calibre.enable = true;
      dbeaver.enable = true;
      discord.enable = true;
      element.enable = true;
      firefox.enable = true;
      freecad.enable = true;
      gimp.enable = true;
      google-chrome.enable = true;
      inkscape.enable = true;
      libreoffice.enable = true;
      lite-xl.enable = true;
      microsoft-edge.enable = true;
      microsoft-outlook.enable = true;
      microsoft-teams.enable = true;
      nrf-connect.enable = true;
      obs-studio.enable = true;
      obsidian.enable = true;
      prusa-slicer.enable = true;
      qmk.enable = true;
      sublime-text.enable = true;
      spotify.enable = true;
      toggl-track.enable = true;
      via.enable = true;
      vlc.enable = true;
      vscode.enable = true;
      zed.enable = true;
    };
    cli = {
      ruff.enable = true;
      step-cli.enable = true;
    };
    services = {
      docker = {
        enable = true;
        rootless = true;
      };
      flatpak.enable = true;
      fprintd.enable = true;
      syncthing.enable = true;
    };
    system = {
      bluetooth.enable = true;
      firewall.enable = true;
      gpu-nvidia.enable = true;
      pipewire.enable = true;
      wallpaper = {
        enable = true;
        path = ../../assets/wallpapers/wallhaven-z8zl6o.jpg;
      };
    };
  };
}
