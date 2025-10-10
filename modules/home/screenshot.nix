{ config, pkgs, ... }:

{
  # req's
  home.packages = with pkgs; [
    gnome-screenshot
    swappy
    wl-clipboard
    satty
    libnotify
    xdg-utils
  ];

  # screenshot script
  home.file.".local/bin/screenshot.hm-init" = {
    text = ''
      #!/usr/bin/env bash
      set -e

      # tmpfile and outfile
      tmpfile=$(mktemp --suffix=.png)
      outfile=~/Pictures/Screenshots/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png
      trap 'echo "Cleaning up..."; rm -f "$tmpfile"' EXIT

      # screenshot
      gnome-screenshot -a -f "$tmpfile"

      # edit/annotate
      satty \
          --filename "$tmpfile" \
          --output-filename "$outfile" \
          --initial-tool rectangle \
          --actions-on-escape save-to-file,exit \
          --actions-on-enter save-to-file,exit \
          --no-window-decoration

      # copy to clipboard
      wl-copy < "$outfile"

      # notification (click to open containing folder)
      action=$(notify-send "Screenshot" "$(basename "$outfile")" -i image-x-generic -a "screenshot" -t 5000 --action=open_folder="View Screenshot")
      if [ "$action" = "open_folder" ]; then
          xdg-open "$(dirname "$outfile")"
      fi
    '';
    onChange = ''
      rm -f .local/bin/screenshot
      cp .local/bin/screenshot.hm-init .local/bin/screenshot
      chmod u+x .local/bin/screenshot
    '';
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom0" = {
      binding = "Print";
      command = "screenshot";
      name = "Screenshot";
    };
  };
}
