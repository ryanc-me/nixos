{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./dconf.nix
    ./bash.nix
  ];

  home.username = "ryan";
  home.homeDirectory = "/home/${config.home.username}";

  mine.home = {
    apps = {
      screenshot.enable = true;
    };
    services = {
      docker-socket-tunnel.enable = true;
      flatpak.enable = true;
      ssh-agent.enable = true;
    };
    system = {
      electron-wayland.enable = true;
      fonts.enable = true;
    };
  };

  # this is require for syncthing (hence it lives here, not in a module)
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ryan Cole";
        email = "admin@ryanc.me";
      };
    };
  };

  stylix = {
    targets = {
      vscode.enable = true;
      fuzzel.enable = true;
      qt.enable = true;
      qt.standardDialogs = "xdgdesktopportal";
    };
  };

  #TODO: move this to the NixOS side for better perf?
  # https://github.com/nix-community/impermanence/issues/42#issuecomment-951093430
  home.persistence."/persist/sync" = {
    files = [
      ".config/Code/User/settings.json"
    ];
    directories = [
      ".config/forge"
      ".config/noctalia"
      ".config/niri"

      ".ssh"
      ".aws"

      "projects"
      "work"
    ];
  };

  # TODO: only when desktop-niri is enabled, only for idir
  home.file.".local/bin/left-monitor.hm-init" = {
    text = ''
      #!/usr/bin/env bash
      set -eu

      niri msg action focus-workspace "side" || true

      microsoft-outlook &
      microsoft-teams &
      spotify &
      toggl-track &
      subl &

      sleep 1

      niri msg action focus-column-first
      niri msg action set-column-display tabbed


      subl_window_id=$(niri msg --json windows | ${pkgs.jq}/bin/jq -r --arg app "sublime_text" '
          [.[] | select(.app_id == $app)] | first | .id // empty
      ')

      echo "subl_window_id = ''${subl_window_id}"
      app_ids='
      msedge-outlook.office.com__mail_-Default
      msedge-teams.microsoft.com__v2_-Default
      msedge-open.spotify.com__-Default
      msedge-track.toggl.com__-Default
      '
      for app in $app_ids; do
          window_id=$(niri msg --json windows | ${pkgs.jq}/bin/jq -r --arg app "$app" '
              [.[] | select(.app_id == $app)] | first | .id // empty
          ')
          echo "window_id for ''${app} = ''${window_id}"
          niri msg action focus-window --id "$window_id"
          niri msg action move-column-to-index 2
          niri msg action focus-window --id "$subl_window_id"
          niri msg action consume-window-into-column || true
      done
    '';
    onChange = ''
      rm -f .local/bin/left-monitor
      cp .local/bin/left-monitor.hm-init .local/bin/left-monitor
      chmod u+x .local/bin/left-monitor
    '';
  };

  home.stateVersion = "25.05";
}
