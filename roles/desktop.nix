{
  # a graphical desktop environment with common applications
  mine.nixos = {
    apps = {
      onepassword.enable = true;
      blender.enable = true;
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
      lutris.enable = true;
      microsoft-edge.enable = true;
      obs-studio.enable = true;
      obsidian.enable = true;
      prusa-slicer.enable = true;
      steam.enable = true;
      sublime-text.enable = true;
      vlc.enable = true;
      vscode.enable = true;
    };
    cli = {
      git.enable = true;
      ruff.enable = true;
      step-cli.enable = true;
    };
    desktop = {
      gnome = {
        enable = true;
        extensions = [
          "blur-my-shell"
          "just-perfection"
          "caffeine"
          "tailscale-qs"
          "emoji-copy"
          "iso-clock"
          "clipboard-indicator"
          "color-picker"
          "launch-new-instance"
          "forge"
          "status-area-horizontal-spacing"
          "appindicator"
        ];
      };
      wallpaper = {
        enable = true;
        path = ../assets/wallpapers/wallhaven-o5g125.jpg;
      };
    };
    services = {
      docker.enable = true;
      flatpak.enable = true;
      sshd.enable = true;
      syncthing.enable = true;
    };
    system = {
      bluetooth.enable = true;
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
      pipewire.enable = true;
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
