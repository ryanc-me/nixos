{
  # a graphical desktop environment with common applications
  mine = {
    apps = {
      onepassword.enable = true;
      blender.enable = true;
      calibre.enable = true;
      dbeaver.enable = true;
      element.enable = true;
      firefox.enable = true;
      freecad.enable = true;
      gimp.enable = true;
      google-chrome.enable = true;
      inkscape.enable = true;
      libreoffice.enable = true;
      microsoft-edge.enable = true;
      microsoft-outlook.enable = true;
      microsoft-teams.enable = true;
      obs-studio.enable = true;
      obsidian.enable = true;
      steam.enable = true;
      sublime-text.enable = true;
      toggl-track.enable = true;
      vlc.enable = true;
      vscode.enable = true;
    };
    cli = {
      git.enable = true;
      ruff.enable = true;
      step-cli.enable = true;
    };
    desktop = {
      gnome.enable = true;
      wallpaper = {
        enable = true;
        path = ../assets/wallpapers/wallhaven-o5g125.jpg;
      };
    };
    services = {
      docker.enable = true;
      flatpak.enable = true;
      sshd.enable = true;
    };
    system = {
      boot = {
        plymouth.enable = true;
        systemd.enable = true;
      };
      firewall = { };
      home-manager.enable = true;
      impermanence.enable = true;
      networking = {
        networkmanager.enable = true;
      };
      utils = {
        enable = true;
      };
      users = {
        ryan.enable = true;
        angel.enable = true;
      };
    };
  };
}
